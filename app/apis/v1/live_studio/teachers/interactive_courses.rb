module V1
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
                optional :page, type: Integer
                optional :per_page, type: Integer
                optional :status, type: String, desc: '状态 init: 初始化; published: 招生中; teaching: 已开课; completed: 已结束; refunded: 已结束 退款; finished: 已结束(包含退款[completed&refunded])', values: %w(init published teaching completed refunded finished)
              end
              get 'interactive_courses' do
                course_data = LiveService::TeacherInteractiveCourseDirector.new(@teacher)
                interactive_courses = course_data.interactive_courses(params).order(id: :desc).paginate(page: params[:page], per_page: params[:per_page])
                present interactive_courses, with: Entities::LiveStudio::InteractiveCourse
              end
            end
          end
        end
      end
    end
  end
end
