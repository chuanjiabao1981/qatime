module V1
  # 视频课接口
  module LiveStudio
    class VideoCourses < V1::Base
      namespace "live_studio" do
        resource :video_courses do
          desc '搜索视频课'
          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
            optional :q, type: Hash, default: {} do
              optional :grade_eq, type: String, desc: '年级', values: APP_CONSTANT['grades_in_menu']
              optional :subject_eq, type: String, desc: '科目', values: APP_CONSTANT['subjects']
              optional :sell_type_eq, type: String, desc: '销售类型 charge: 收费; free: 免费', values: %w[charge free]
            end
            optional :sort_by, type: String, desc: '排序方式', values: %w(price price.asc published_at published_at.asc buy_tickets_count buy_tickets_count.asc)
          end
          get 'search' do
            search_params = ActionController::Parameters.new(params).permit(:sort_by, q: [:status_eq, :grade_eq, :subject_eq, :sell_type_eq])
            sell_type_value = ::LiveStudio::VideoCourse.sell_type.find_value(search_params[:q][:sell_type_eq]).try(:value)
            search_params[:q][:sell_type_eq] = sell_type_value if sell_type_value
            search_params[:q][:s] =
                if search_params[:sort_by].present?
                  by, direction = search_params[:sort_by].split('.')
                  "#{by} #{direction || 'desc'}"
                else
                  'published_at desc'
                end
            q = LiveService::VideoCourseDirector.search(search_params)
            video_courses = q.result.paginate(page: params[:page], per_page: params[:per_page])
            present video_courses, with: Entities::LiveStudio::SearchVideoCourse, type: :full
          end

          desc '视频课详情' do
            headers 'Remember-Token' => {
                        description: 'RememberToken',
                        required: false
                    }
          end
          params do
            requires :id, type: Integer, desc: 'ID'
          end
          get ':id' do
            video_course = ::LiveStudio::VideoCourse.find(params[:id])
            case current_user
              when Student
                present video_course, with: Entities::LiveStudio::StudentVideoCourse, type: :full, current_user: current_user
              when Teacher
                present video_course, with: Entities::LiveStudio::TeacherVideoCourse, type: :full, current_user: current_user
              else
                present video_course, with: Entities::LiveStudio::VideoCourse, type: :full
            end
          end

          desc '新视频课详情' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
            }
          end
          params do
            requires :id, type: Integer, desc: 'ID'
          end
          get ':id/detail' do
            video_course = ::LiveStudio::VideoCourse.find(params[:id])
            ticket = video_course.tickets.available.find_by(student: current_user) if current_user
            present video_course, root: :video_course, with: Entities::LiveStudio::VideoCourseBase
            present ticket, root: :ticket, with: Entities::LiveStudio::VideoCourseTicket, type: :full
          end
        end

        resource :video_courses do
          before do
            authenticate!
          end

          desc '购买视频课' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, desc: '视频课ID'
            requires :pay_type, type: String, values: ::Payment::Order.pay_type.values, desc: '支付方式'
            optional :coupon_code, type: String, desc: '使用优惠码(可不填)'
          end
          post '/:id/orders' do
            course = ::LiveStudio::VideoCourse.find(params[:id])
            order = ::Payment::Order.new(course.order_params.merge(pay_type: params[:pay_type], remote_ip: client_ip, source: :app, user: current_user))
            if params[:coupon_code].present?
              coupon = ::Payment::Coupon.find_by(code: params[:coupon_code])
              order.amount = course.coupon_price(coupon)
              order.coupon = coupon
            end
            order.save
            raise ActiveRecord::RecordInvalid, order if order.errors.any?
            present order, with: Entities::Payment::Order
          end

          desc '购买免费的视频课(无需下单直接出票)' do
            headers 'Remember-Token' => {
                        description: 'RememberToken',
                        required: true
                    }
          end
          params do
            requires :id, desc: '视频课ID'
          end
          post '/:id/deliver_free' do
            video_course = ::LiveStudio::VideoCourse.find(params[:id])
            ticket = video_course.deliver_free(current_user)
            raise ActiveRecord::RecordNotFound if ticket.blank?
            present ticket, with: Entities::LiveStudio::Ticket
          end

          desc '试听视频课' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, desc: '视频课ID'
          end
          post '/:id/taste' do
            video_course = ::LiveStudio::VideoCourse.find(params[:id])
            ticket = LiveService::VideoCourseDirector.new(video_course).taste(current_user)
            present ticket, with: Entities::LiveStudio::Ticket
          end
        end
      end
    end
  end
end
