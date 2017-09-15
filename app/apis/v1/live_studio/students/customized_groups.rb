module V1
  # 一对一直播接口
  module LiveStudio
    module Students
      class CustomizedGroups < V1::Base
        namespace "live_studio" do
          namespace :students do
            before do
              authenticate!
            end
            route_param :student_id do
              helpers do
                def auth_params
                  @student ||= ::Student.find_by(id: params[:student_id])
                end
              end

              resource :customized_groups do
                desc '我的专属课' do
                  headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
                end
                params do
                  requires :student_id, type: Integer
                  optional :status, type: String, desc: '状态 published: 待开课, teaching: 已开课, completed: 已结束', values: %w(published teaching completed)
                  optional :page, type: Integer
                  optional :per_page, type: Integer
                  optional :sell_type, type: String, desc: '购买状态 charge: 已购; free: 免费', values: %w(charge free)
                end
                get '' do
                  # 目前保存product_type只能保存为LiveStudio::Group
                  tickets = @student.live_studio_buy_tickets.available.where(product_type: 'LiveStudio::Group').includes(product: :teacher)
                  tickets = params[:sell_type] == 'free' ? tickets.where('payment_order_id is null') : tickets.where('payment_order_id is not null')
                  status = ::LiveStudio::CustomizedGroup.statuses.values_at(*params[:status].to_s.split(/[\s,]+/))
                  tickets = tickets.joins('left join live_studio_groups on live_studio_groups.id = live_studio_tickets.product_id').where('live_studio_groups.status in ?', status) unless status.blank?
                  tickets = tickets.paginate(page: params[:page], per_page: params[:per_page])
                  present tickets, with: Entities::LiveStudio::CustomizedGroupTicket, type: :full
                end

                desc '我的试听专属课' do
                  headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
                end
                params do
                  requires :student_id, type: Integer
                  optional :page, type: Integer
                  optional :per_page, type: Integer
                end
                get 'tasting' do
                  # 目前保存product_type只能保存为LiveStudio::Group
                  tickets = @student.live_studio_taste_tickets.available.where(product_type: 'LiveStudio::Group')
                  tickets = tickets.paginate(page: params[:page], per_page: params[:per_page])
                  present tickets, with: Entities::LiveStudio::CustomizedGroupTicket, type: :full
                end
              end
            end
          end
        end
      end
    end
  end
end
