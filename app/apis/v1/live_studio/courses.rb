module V1
  # 辅导班接口
  module LiveStudio
    class Courses < Grape::API
      namespace "live_studio/teacher", path: "live_studio" do
        before do
          @current_user ||= ::Teacher.last
        end

        resource :courses do
          desc '辅导班列表接口'
          params do
          end
          get do
            courses = @current_user.live_studio_courses
            present courses, with: Entities::LiveStudio::Course, type: :default
          end

          desc '辅导班全信息接口'
          params do
          end
          get :full do
            courses = @current_user.live_studio_courses
            present courses, with: Entities::LiveStudio::Course, type: :full
          end
        end

        desc '辅导班详情接口'
        params do
          requires :id, type: Integer, desc: '辅导班ID'
        end
        get 'courses/:id' do
          course = @current_user.live_studio_courses.find(params[:id])
          present course, with: Entities::LiveStudio::Course, type: :full
        end
      end
    end
  end
end
