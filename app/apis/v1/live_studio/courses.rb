module V1
  # 辅导班接口
  module LiveStudio
    class Courses < V1::Base
      namespace "live_studio" do
        namespace :teachers do
          before do
            authenticate!
          end

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


            desc '直播开始接口' do
              headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
              }
            end
            params do
              requires :lesson_id, type: Integer, desc: '课程ID'
            end
            get :live_start do
              @lesson = ::LiveStudio::Lesson.find(params[:lesson_id])
              LiveService::LessonDirector.new(@lesson).lesson_start
              @lesson.current_live_session.token
            end

            desc '直播心跳通知接口' do
              headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
              }
            end
            params do
              requires :lesson_id, type: Integer, desc: '课程ID'
              optional :token, type: String, desc: '心跳token'
            end
            get :heartbeat do
              @lesson = ::LiveStudio::Lesson.find(params[:lesson_id])
              @lesson.heartbeats(params[:token])
            end

            desc '直播结束接口' do
              headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
              }
            end
            params do
              requires :lesson_id, type: Integer, desc: '课程ID'
            end
            get :live_end do
              @lesson = ::LiveStudio::Lesson.find(params[:lesson_id])
              @lesson.close!
            end
          end
        end
      end
    end
  end
end
