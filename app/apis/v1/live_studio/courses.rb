module V1
  # 系统环境
  module LiveStudio
    class Courses < Grape::API
      namespace "live_studio/teacher", path: "live_studio" do
        resource :courses do
          before do
            @current_user ||= ::Teacher.last
            ATTRIBUTES_ARR = [:name, :subject, :status, :description, :lesson_count, :preset_lesson_count, :completed_lesson_count].freeze
          end

          desc '辅导班列表接口'
          params do
          end
          get do
            courses_data = @current_user.live_studio_courses.map do |course|
              {}.tap do |h|
                ATTRIBUTES_ARR.each do |attri|
                  h[attri] = course.send attri
                end
              end
            end

            { info: { courses: courses_data } }
          end

          desc '辅导班全信息接口'
          params do
          end
          get :full do
            courses_data = @current_user.live_studio_courses

            { info: { courses: courses_data } }
          end

          route_param :id do
            desc '辅导班详情接口'
            params do
              requires :id, type: Integer, desc: '辅导班ID'
            end
            get do
              course = @current_user.live_studio_courses.find(params[:id])
              course_data = {}.tap do |h|
                ATTRIBUTES_ARR.each do |attri|
                  h[attri] = course.send attri
                end
              end

              { info: { course: course_data } }
            end
        end
        end
      end
    end
  end
end
