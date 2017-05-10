module V1
  # 视频课接口
  module LiveStudio
    class VideoLessons < V1::Base
      namespace "live_studio" do
        resource :video_lessons do
          before do
            authenticate!
          end

          desc '视频课程播放' do
            headers 'Remember-Token' => {
                        description: 'RememberToken',
                        required: true
                    }
          end
          params do
            requires :id, type: Integer, desc: "视频课程ID"
          end
          get ':id/play' do
            video_lesson = ::LiveStudio::VideoLesson.find(params[:id])
            ticket = ::LiveService::VideoCourseDirector.play_authorize!(current_user, video_lesson)
            raise "未购买" unless ticket
            present video_lesson, root: :video_lesson, with: Entities::LiveStudio::VideoLessonPlay
            present ticket, root: :ticket, with: Entities::LiveStudio::VideoCourseTicket, type: :full if current_user.student?
          end
        end
      end
    end
  end
end
