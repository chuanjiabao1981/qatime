module V1
  # 系统环境
  module LiveStudio
    class Courses < Grape::API
      namespace :live_studio do
        helpers do
          def current_user
            @current_user ||= ::Teacher.last
          end
        end

        resource :courses do
          desc '辅导班列表.'
          params do
          end
          get :courses do
            courses = current_user.live_studio_courses.map do |course|
              {}.tap do |h|
                [:name, :description, :price, :lesson_count, :preset_lesson_count, :completed_lesson_count].each do |attri|
                  h[attri] = course.send attri
                end
              end
            end
            { info: { courses: courses } }
          end
        end
      end
    end
  end
end
