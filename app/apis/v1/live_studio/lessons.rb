module V1
  # 辅导班接口
  module LiveStudio
    class Lessons < V1::Base
      namespace "live_studio" do
        resource :lessons do
          before do
            authenticate!
          end

          desc '直播开始接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
          end
          get ':id/live_start' do
            @lesson = ::LiveStudio::Lesson.find(params[:id])
            raise_change_error_for(@lesson.ready? || @lesson.paused? || @lesson.closed?)
            LiveService::LessonDirector.new(@lesson).lesson_start
            @lesson.current_live_session.token
            present @lesson, with: Entities::LiveStudio::Lesson, type: :live_start
          end

          desc '直播心跳通知接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
            optional :token, type: String, desc: '心跳token'
          end
          get ':id/heartbeat' do
            @lesson = ::LiveStudio::Lesson.find(params[:id])
            raise_change_error_for(@lesson.teaching? || @lesson.paused?)
            @lesson.heartbeats(params[:token])
            present @lesson, with: Entities::LiveStudio::Lesson, type: :live_start
          end

          desc '直播结束接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
          end
          get ':id/live_end' do
            @lesson = ::LiveStudio::Lesson.find(params[:id])
            raise_change_error_for(@lesson.teaching? || @lesson.paused?)
            @lesson.close!
            present @lesson, with: Entities::LiveStudio::Lesson, type: :live_start
          end

          desc '直播完成接口 - 不可继续直播' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
          end
          put ':id/finish' do
            @lesson = ::LiveStudio::Lesson.find(params[:id])
            raise_change_error_for(@lesson.teaching? || @lesson.paused? || @lesson.closed?)
            LiveService::LessonDirector.new(@lesson).finish
            present @lesson, with: Entities::LiveStudio::Lesson
          end
        end
      end
    end
  end
end
