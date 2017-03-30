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
                requires :student_id, type: Integer
                optional :page, type: Integer
                optional :per_page, type: Integer
              end
              get 'interactive_courses' do
                interactive_courses = LiveService::StudentLiveDirector.new(@student).interactive_courses.paginate(page: params[:page], per_page: params[:per_page])
                present interactive_courses, with: Entities::LiveStudio::StudentInteractiveCourse, type: :default
              end
            end
          end
        end
      end
    end
  end
end
