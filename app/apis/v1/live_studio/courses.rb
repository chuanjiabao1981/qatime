module V1
  # 辅导班接口
  module LiveStudio
    class Courses < V1::Base
      namespace "live_studio" do
        namespace :teachers do
          route_param :teacher_id do
            resource :courses do
              desc '辅导班列表接口' do
                headers 'Remember-Token' => {
                          description: 'RememberToken',
                          required: true
                        }
              end
              params do
                optional :page, type: Integer
                optional :per_page, type: Integer
              end
              get do
                courses = current_user.live_studio_courses
                present courses, with: Entities::LiveStudio::Course, type: :default
              end

              desc '辅导班全信息接口' do
                headers 'Remember-Token' => {
                          description: 'RememberToken',
                          required: true
                        }
              end
              params do
                optional :page, type: Integer
                optional :per_page, type: Integer
              end
              get :full do
                courses = current_user.live_studio_courses
                present courses, with: Entities::LiveStudio::Course, type: :full
              end

              desc '辅导班详情接口' do
                headers 'Remember-Token' => {
                          description: 'RememberToken',
                          required: true
                        }
              end
              params do
                requires :id, type: Integer, desc: '辅导班ID'
                optional :page, type: Integer
                optional :per_page, type: Integer
              end
              get 'courses/:id' do
                course = current_user.live_studio_courses.find(params[:id])
                present course, with: Entities::LiveStudio::Course, type: :full
              end
            end
          end
        end
      end
    end
  end
end
