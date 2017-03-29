module V1
  # 辅导班接口
  module LiveStudio
    module Students
      class InteractiveCourses < V1::Base
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

              desc '我的一对一直播' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
              end
              get 'interactive_courses' do
                interactive_tickets = @student.live_studio_tickets.visiable.where(product_type: 'LiveStudio::InteractiveCourse').includes(:product)
                present interactive_tickets, with: Entities::LiveStudio::InteractiveTicket
              end
            end
          end
        end
      end
    end
  end
end
