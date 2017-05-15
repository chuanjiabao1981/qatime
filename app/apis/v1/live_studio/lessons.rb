module V1
  # 辅导班接口
  module LiveStudio
    class Lessons < V1::Base
      namespace "live_studio" do
        resource :lessons do
          before do
            authenticate!
          end

          desc '直播信息接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
          end
          get ':id/live_info' do
            @lesson = ::LiveStudio::Lesson.find(params[:id])
            {
              board_push_stream: @lesson.course.pull_streams.find {|stream| stream.use_for == 'board' }.try(:address),
              camera_push_stream: @lesson.course.pull_streams.find {|stream| stream.use_for == 'camera' }.try(:address),
              beat_step: ::LiveStudio::Lesson.beat_step
            }
          end

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
          end
          post ':id/live_start' do
            @lesson = ::LiveStudio::Lesson.find(params[:id])
            if @lesson.ready? || @lesson.paused? || @lesson.closed?
              LiveService::LessonDirector.new(@lesson).lesson_start(params[:board], params[:camera])
            end
            {
              status: @lesson.status,
              live_token: @lesson.current_live_session.token,
              beat_step: ::LiveStudio::Lesson.beat_step
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
            requires :camera, type: Integer,values: [0, 1, 2], desc: '是否开始直播摄像头. 1: 是, 0: 否, 2: 已关闭'
          end
          post ':id/live_switch' do
            @lesson = ::LiveStudio::Lesson.find(params[:id])
            LiveService::LessonDirector.live_status_change(@lesson.course, params[:board], params[:camera], @lesson)
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
            optional :timestamp, type: Integer, desc: '心跳间隔 单位:秒'
          end
          post ':id/heart_beat' do
            @lesson = ::LiveStudio::Lesson.find(params[:id])
            live_token = params[:beat_step].blank? ? @lesson.current_live_session.token :
              @lesson.heartbeats(params[:timestamp], params[:beat_step].to_i, params[:live_token])
            # 更新缓存
            LiveService::RealtimeService.new(@lesson.course_id).touch_live
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
          end
          post ':id/live_end' do
            @lesson = ::LiveStudio::Lesson.find(params[:id])
            @lesson.close!
            LiveService::LessonDirector.live_status_change(@lesson.course, 0, 0, @lesson)
            {
              result: 'ok',
              status: @lesson.status
            }
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
            # raise_change_error_for(@lesson.teaching? || @lesson.paused? || @lesson.closed?)
            if @lesson.teaching? || @lesson.paused? || @lesson.closed?
              LiveService::LessonDirector.new(@lesson).finish
            end
            present @lesson, with: Entities::LiveStudio::Lesson
          end

          desc '回放视频信息接口' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: Integer, desc: '课程ID'
          end
          get ':id/replay' do
            @lesson = ::LiveStudio::Lesson.find(params[:id])
            @course = @lesson.course
            ::LiveStudio::PlayRecord.init_play(current_user, @lesson.course, @lesson)
            @paly_records = ::LiveStudio::PlayRecord.where(lesson_id: @lesson.id,
                                                           play_type: ::LiveStudio::PlayRecord.play_types[:replay],
                                                           user_id: current_user.id).where('created_at < ?', Date.today).to_a
            @lesson.replay_times = @paly_records.count
            present @lesson, with: Entities::LiveStudio::VideoLesson, type: :full, current_user: current_user
          end
        end

        resource :lessons do
          desc '今日直播'
          get 'today' do
            home_data = DataService::HomeData.new
            lessons = home_data.today_lives
            present lessons, with: ::Entities::LiveStudio::TodayLesson
          end
        end
      end
    end
  end
end
