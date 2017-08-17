module V1
  # 专属课直播接口
  module LiveStudio
    class ScheduledLessons < V1::Base
      namespace "live_studio" do
        resource :scheduled_lessons do
          before do
            authenticate!
          end

          desc '专属课回放视频信息接口' do
            headers 'Remember-Token' => {
                        description: 'RememberToken',
                        required: true
                    }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
          end
          get ':id/replay' do
            @lesson = ::LiveStudio::ScheduledLesson.find(params[:id])
            @course = @lesson.group
            ::LiveStudio::PlayRecord.init_play(current_user, @course, @lesson)

            present @lesson, with: Entities::LiveStudio::ScheduledLessonReplay, current_user: current_user
          end
        end
      end
    end
  end
end
