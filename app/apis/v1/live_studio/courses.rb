module V1
  # 辅导班接口
  module LiveStudio
    class Courses < V1::Base
      namespace "live_studio/teacher", path: "live_studio" do
        before do
          @current_user ||= ::Teacher.last
          COURSE_ATTR = [:name, :subject, :status, :description, :lesson_count, :preset_lesson_count, :completed_lesson_count].freeze
          LESSON_ATTR = [:name, :status_text, :class_date, :live_time].freeze
        end

        resource :courses do
          desc '辅导班列表接口'
          params do
          end
          get do
            # courses_data = @current_user.live_studio_courses.map do |course|
            #   {}.tap do |h|
            #     COURSE_ATTR.each do |attri|
            #       h[attri] = course.send attri
            #     end
            #   end
            # end
            courses = @current_user.live_studio_courses
            present courses, with: Entities::LiveStudio::Course, type: :default
          end

          desc '辅导班全信息接口'
          params do
          end
          get :full do
            courses_data = @current_user.live_studio_courses.map do |course|
              {}.tap do |h|
                COURSE_ATTR.each do |attri|
                  h[attri] = course.send attri
                end

                h[:lessons] = course.lessons.map do |lesson|
                  {}.tap do |h2|
                    LESSON_ATTR.each do |attri2|
                      h2[attri2] = lesson.send attri2
                    end
                  end
                end
              end
            end

            { courses: courses_data }
          end
        end

        desc '辅导班详情接口'
        params do
          requires :id, type: Integer, desc: '辅导班ID'
        end
        get 'courses/:id' do
          course = @current_user.live_studio_courses.find(params[:id])
          course_data = {}.tap do |h|
            COURSE_ATTR.each do |attri|
              h[attri] = course.send attri
            end

            h[:lessons] = course.lessons.map do |lesson|
              {}.tap do |h2|
                LESSON_ATTR.each do |attri2|
                  h2[attri2] = lesson.send attri2
                end
              end
            end
          end

          { course: course_data }
        end
      end
    end
  end
end
