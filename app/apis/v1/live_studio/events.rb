module V1
  # 线上课接口
  module LiveStudio
    class Events < V1::Base
      namespace "live_studio" do
        before do
          authenticate!
        end

        helpers do
          def auth_params
            @event ||= ::LiveStudio::Event.find(params[:id])
          end
        end

        resource :events do
          desc '直播开始接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
            requires :board, type: Integer, values: [0, 1, 2], desc: '是否开始直播白板. 1: 是, 0: 否, 2: 已关闭'
            requires :camera, type: Integer, values: [0, 1, 2], desc: '是否开始直播摄像头. 1: 是, 0: 否, 2: 已关闭'
            optional :t, type: Integer, desc: '时间戳秒数'
          end
          post ':id/live_start' do
            Qatime::Util.sequence_exec("#{@event.model_name.cache_key}/#{@event.id}/live", params[:t]) do
              @live_session = LiveService::EventDirector.new(@event).live_start(params[:board], params[:camera])
            end
            {
              status: @event.status,
              live_token: @live_session.try(:token),
              beat_step: ::LiveStudio::Group.beat_step
            }
          end

          desc '直播状态切换接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
            requires :board, type: Integer, values: [0, 1, 2], desc: '是否开始直播白板. 1: 是, 0: 否, 2: 已关闭'
            requires :camera, type: Integer, values: [0, 1, 2], desc: '是否开始直播摄像头. 1: 是, 0: 否, 2: 已关闭'
          end
          post ':id/live_switch' do
            LiveService::EventDirector.live_status_change(@event.group, params[:board], params[:camera], @event)
            'ok'
          end

          desc '直播心跳通知接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
            optional :live_token, type: String, desc: '心跳token'
            optional :beat_step, type: String, desc: '心跳间隔 单位:秒'
            optional :timestamp, type: Integer, desc: '心跳时间戳'
          end
          post ':id/heart_beat' do
            live_token = LiveService::EventDirector.new(@event).heartbeats(params[:timestamp], params[:beat_step].to_i, params[:live_token])
            {
              result: 'ok',
              live_token: live_token
            }
          end

          desc '直播结束接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
            optional :t, type: Integer, desc: '时间戳秒数'
          end
          post ':id/live_end' do
            Qatime::Util.sequence_exec("#{@event.model_name.cache_key}/#{@event.id}/live", params[:t]) do
              @event.close! if @event.teaching? || @event.pause
              LiveService::EventDirector.live_status_change(@event.group, 0, 0, @event)
            end
            {
              result: 'ok',
              status: @event.status
            }
          end
        end
      end
    end
  end
end
