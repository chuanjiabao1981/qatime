module V1
  module LiveStudio
    module Students
      class VideoCourses < V1::Base
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

              desc '我的视频课' do
                headers 'Remember-Token' => {
                            description: 'RememberToken',
                            required: true
                        }
              end
              params do
                requires :student_id, type: Integer
                optional :page, type: Integer
                optional :per_page, type: Integer
                optional :sell_type, type: String, desc: '查询状态 charge: 已购; free: 免费', values: %w(charge free)
              end
              get 'video_courses' do
                video_courses = LiveService::StudentLiveDirector.new(@student).video_courses(params).paginate(page: params[:page], per_page: params[:per_page])
                present video_courses, with: Entities::LiveStudio::StudentVideoCourse, type: :full
              end

              desc '我的试听视频课' do
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
              get 'video_courses/tasting' do
                video_courses = @student.live_studio_taste_video_courses.paginate(page: params[:page], per_page: params[:per_page])
                present video_courses, with: Entities::LiveStudio::StudentVideoCourse
              end
            end
          end
        end
      end
    end
  end
end
