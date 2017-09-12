module V1
  # 辅导班接口
  module LiveStudio
    class InteractiveLessons < V1::Base
      namespace "live_studio" do
        resource :interactive_lessons do
          before do
            authenticate!
          end

          route_param :id do
            helpers do
              def auth_params
                @interactive_lesson ||= ::LiveStudio::InteractiveLesson.find(params[:id])
              end
            end

            desc '开始上课' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :id, type: Integer, desc: '课程ID'
              requires :room_id, type: String, desc: '房间ID'
              optional :camera, type: Integer, values: [0, 1, 2], desc: '是否开始直播摄像头. 1: 是, 0: 否'
              optional :t, type: Integer, desc: '时间戳秒数'
              requires :channel_id, type: String, desc: 'channel_id'
            end
            post 'live_start' do
              Qatime::Util.sequence_exec("#{@interactive_lesson.model_name.cache_key}/#{@interactive_lesson.id}/live", params[:t]) do
                if @interactive_lesson.ready? || @interactive_lesson.paused? || @interactive_lesson.closed?
                  director = LiveService::InteractiveLessonDirector.new(@interactive_lesson)
                  director.lesson_start(0, params[:camera].to_i, params[:room_id], params[:channel_id])
                end
              end
              {
                status: @interactive_lesson.status,
                live_token: @interactive_lesson.current_live_session.token,
                beat_step: ::LiveStudio::InteractiveLesson.beat_step
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
              requires :camera, type: Integer, values: [0, 1, 2], desc: '是否开始直播摄像头. 1: 是, 0: 否'
            end
            post 'live_switch' do
              LiveService::InteractiveLessonDirector.live_status_change(@interactive_lesson.interactive_course, 0, params[:camera], @interactive_lesson)
              'ok'
            end

            desc '结束上课' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :id, type: Integer, desc: '课程ID'
              optional :t, type: Integer, desc: '时间戳秒数'
            end
            post 'live_end' do
              @interactive_lesson.room_id = nil
              Qatime::Util.sequence_exec("#{@interactive_lesson.model_name.cache_key}/#{@interactive_lesson.id}/live", params[:t]) do
                @interactive_lesson.close!
                LiveService::InteractiveLessonDirector.live_status_change(@interactive_lesson.interactive_course, 0, 0, @interactive_lesson)
              end
              {
                result: 'ok',
                status: @interactive_lesson.status
              }
            end

            desc '直播心跳' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :id, type: Integer, desc: '课程ID'
              optional :live_token, type: String, desc: '心跳token'
              optional :beat_step, type: String, desc: '心跳间隔 单位:秒'
              optional :timestamp, type: Integer, desc: '心跳间隔 单位:秒'
            end
            post 'heart_beat' do
              live_token = params[:beat_step].blank? ? @interactive_lesson.current_live_session.token :
                @interactive_lesson.heartbeats(params[:timestamp], params[:beat_step].to_i, params[:live_token])
              # 更新缓存
              LiveService::InteractiveRealtimeService.new(@interactive_lesson.interactive_course_id).touch_live
              {
                result: 'ok',
                live_token: live_token
              }
            end

            desc '一对一回放视频信息接口' do
              headers 'Remember-Token' => {
                          description: 'RememberToken',
                          required: true
                      }
            end
            params do
              requires :id, type: Integer, desc: '课程ID'
            end
            get 'replay' do
              ::LiveStudio::PlayRecord.init_play(current_user, @interactive_lesson.interactive_course, @interactive_lesson)
              present @interactive_lesson, with: Entities::LiveStudio::InteractiveLessonReplay, current_user: current_user
            end
          end
        end
      end
    end
  end
end
