module V1
  # 辅导班接口
  module LiveStudio
    class InteractiveLessons < V1::Base
      namespace "live_studio" do
        resource :interactive_lessons do
          before do
            authenticate!
          end

          desc '开始上课' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
          end
          post ':id/live_start' do
          end

          desc '结束上课' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
          end
          post ':id/live_end' do
          end

          desc '直播心跳' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
          end
          post ':id/heart_beat' do
            
          end
        end
      end
    end
  end
end
