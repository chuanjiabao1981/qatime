module V1
  # 辅导班接口
  module LiveStudio
    module Teachers
      class InteractiveCourses < V1::Base
        namespace "live_studio" do
          namespace 'teachers' do
            before do
              authenticate!
            end
            route_param :teacher_id do
              helpers do
                def auth_params
                  @teacher ||= ::Teacher.find_by(id: params[:teacher_id])
                end
              end

              desc '我的一对一直播' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                requires :teacher_id, type: Integer
              end
              get 'interactive_courses' do
                interactive_courses = @teacher.live_studio_interactive_courses
                present interactive_courses, with: Entities::LiveStudio::InteractiveCourse
              end
            end
          end
        end
      end
    end
  end
end
