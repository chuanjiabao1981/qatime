module V1
  # 一对一直播接口
  module LiveStudio
    class CustomizedGroups < V1::Base
      namespace "live_studio" do
        # 无需授权
        resource :customized_groups do
          desc '专属课搜索'
          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
            optional :q, type: Hash, default: {} do
              optional :status_eq, type: String, desc: '状态 published: 招生中; teaching: 已开课', values: %w(published teaching)
              optional :grade_eq, type: String, desc: '年级', values: APP_CONSTANT['grades_in_menu']
              optional :subject_eq, type: String, desc: '科目', values: APP_CONSTANT['subjects']
              optional :sell_type_eq, type: String, desc: '销售类型 charge: 收费; free: 免费', values: %w[charge free]
              optional :start_at_gteq, type: String, desc: '开课日期开始时间'
              optional :end_at_lt, type: String, desc: '开课日期结束时间'
            end
            optional :sort_by, type: String, desc: '排序方式', values: %w(price price.asc published_at published_at.asc users_count users_count.asc buy_tickets_count buy_tickets_count.asc)
          end
          get 'search' do
            search_params = ActionController::Parameters.new(params).permit(:tags, :range, :sort_by, q: [:status_eq, :grade_eq, :subject_eq, :sell_type_eq, :start_at_gteq, :start_at_lt])
            search_params[:q][:status_eq] = ::LiveStudio::CustomizedGroup.statuses[search_params[:q][:status_eq]] if search_params[:q][:status_eq].present?
            search_params[:q][:sell_type_eq] = ::LiveStudio::CustomizedGroup.sell_type.find_value(search_params[:q][:sell_type_eq]).try(:value) if search_params[:q][:sell_type_eq].present?
            search_params[:q][:s] =
              if search_params[:sort_by].present?
                by, direction = search_params[:sort_by].split('.')
                "#{by} #{direction || 'desc'}"
              else
                'published_at desc'
              end
            q = LiveService::GroupDirector.search(search_params)
            groups = q.result.paginate(page: params[:page], per_page: params[:per_page])
            present groups, with: Entities::LiveStudio::Group
          end

          desc '专属课详情' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
            }
          end
          params do
            requires :id, type: Integer, desc: 'ID'
          end
          get ':id/detail' do
            group = ::LiveStudio::CustomizedGroup.find(params[:id])
            ticket = group.tickets.available.find_by(student: current_user) if current_user
            present group, root: :customized_group, with: Entities::LiveStudio::GroupDetail
            present ticket, root: :ticket, with: Entities::LiveStudio::CustomizedGroupTicket if ticket
          end

          desc '成员列表' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
            }
          end
          params do
            requires :id, type: Integer, desc: 'ID'
          end
          get ':id/members' do
            group = ::LiveStudio::CustomizedGroup.find(params[:id])
            members = group.buy_tickets.includes(:student)
            present members, with: Entities::LiveStudio::CourseMember
          end
        end

        # 需要授权
        resource :customized_groups do
          before do
            authenticate!
          end

          helpers do
            def auth_params
              @group ||= ::LiveStudio::CustomizedGroup.find(params[:id])
            end
          end

          desc '专属课购买' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, desc: '小班课ID'
            requires :pay_type, type: String, values: ::Payment::Order.pay_type.values, desc: '支付方式'
            optional :coupon_code, type: String, desc: '使用优惠码(可不填)'
          end
          post '/:id/orders' do
            order = ::Payment::Order.new(@group.order_params.merge(pay_type: params[:pay_type], remote_ip: client_ip,
                                         source: :student_app, user: current_user))
            order.use_coupon(params[:coupon_code])
            order.save
            raise ActiveRecord::RecordInvalid, order if order.errors.any?
            present order, with: Entities::Payment::Order
          end

          desc '直播观看信息' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer
          end
          get ':id/play' do
            ticket = @group.tickets.available.find_by(student: current_user) if current_user
            present @group, root: :customized_group, with: Entities::LiveStudio::GroupPlayDetail
            present ticket, root: :ticket, with: Entities::LiveStudio::CustomizedGroupTicket if ticket
          end

          desc '实时直播状态' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer
          end
          get ':id/realtime' do
            LiveService::GroupRealtimeService.new(@group.id).live_detail(current_user.try(:id))
          end

          desc '专属课发布公告' do
            headers 'Remember-Token' => {
                        description: 'RememberToken',
                        required: true
                    }
          end
          params do
            requires :content, type: String, desc: "公告内容"
          end
          post ':id/announcements' do
            unless @group.chat_team
              ::LiveService::ChatTeamManager.new(nil).instance_team(@group)
              @group.reload
            end
            @announcement = @group.announcements.new(content: params[:content], lastest: true, creator: @group.teacher)
            if @announcement.save
              @group.announcements.where(lastest: true).where("id <> ?", @announcement).update_all(lastest: false)
            end
            "ok"
          end
        end
      end
    end
  end
end
