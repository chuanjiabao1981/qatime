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
          get ':id/start' do
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
            requires :id, type: Integer, desc: '课程ID'
            optional :token, type: String, desc: '心跳token'
          end
          get ':id/heartbeat' do
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
          get ':id/close' do
            @lesson = ::LiveStudio::Lesson.find(params[:lesson_id])
            @lesson.close!
          end
        end
      end
    end
  end
end
