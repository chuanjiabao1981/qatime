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
                  @student ||= ::Teacher.find_by(id: params[:teacher_id])
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
                interactive_courses = @student.interactive_courses.includes(:interactive_course)
                present interactive_courses, with: Entities::LiveStudio::InteractiveCourse
              end

              desc '一对一直播详情' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                requires :teacher_id, type: Integer, desc: '教师ID'
                requires :id, type: Integer, desc: '直播ID'
              end
              get 'interactive_courses' do
                interactive_courses = @student.interactive_courses.find(params[:id])
                present interactive_courses, with: Entities::LiveStudio::InteractiveCourse
              end
            end
          end
        end
      end
    end
  end
end
