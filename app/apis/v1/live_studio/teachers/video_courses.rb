module V1
  module LiveStudio
    module Teachers
      class VideoCourses < V1::Base
        namespace "live_studio" do
          namespace :teachers do
            before do
              authenticate!
            end
            route_param :teacher_id do
              helpers do
                def auth_params
                  @teacher ||= ::Teacher.find_by(id: params[:teacher_id])
                end
              end

              desc '我的视频课' do
                headers 'Remember-Token' => {
                            description: 'RememberToken',
                            required: true
                        }
              end
              params do
                requires :teacher_id, type: Integer
                optional :page, type: Integer
                optional :per_page, type: Integer
                optional :status, type: String, desc: '状态 init_rejected: 审核中; published: 已发布;', values: %w(init_rejected published)
              end
              get 'video_courses' do
                video_courses = LiveService::TeacherVideoCourseDirector.new(@teacher).video_courses(params).paginate(page: params[:page], per_page: params[:per_page])
                present video_courses, with: Entities::LiveStudio::TeacherVideoCourse, type: :full
              end
            end
          end
        end
      end
    end
  end
end
