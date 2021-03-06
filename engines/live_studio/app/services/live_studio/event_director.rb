module LiveStudio
  class EventDirector
    def initialize(event, start_at = nil, end_at = nil)
      @event = event
      @start_at = start_at
      @end_at = end_at
    end

    # 课程开始 目前支持线下课
    def start(t)
      return if t && t != @event.start_at.to_i
      @event.teach! if @event.class_date.today?
    end

    # 课程结束 目前支持线下课
    def close(t)
      return if t && t != @event.end_at.to_i
      return unless @event.teaching?
      @event.close!
      @event.finish!
    end

    # 直播状态
    def notify_team(action)
      msg = { type: @event.model_name.to_s, event: action }.to_json
      Netease::IM::Service.send_msg(
        from: teacher_account.accid, # 教师accid
        ope: 1, # 群消息
        to: chat_team.team_id, # 发送群组ID
        type: '100', # 自定义消息
        body: msg
      )
    end

    def async_notify_team(action)
      LiveStudio::EventScheduleJob.perform_later(@event.id, 'notify_team', action)
    end

    # 开始任务
    def start_schedule
      schedule(@event.start_at, 'start')
    end

    # 结束任务
    def close_schedule
      schedule(@event.end_at, 'close')
    end

    def self.dispatch_today_events
      LiveStudio::OfflineLesson.today.each do |event|
        director = LiveStudio::EventDirector.new(event)
        # 课程开始
        director.start_schedule
        # 课程结束
        director.close_schedule
      end
    end

    private

    def schedule(t, action)
      LiveStudio::EventScheduleJob.set(wait_until: t).perform_later(@event.id, action, t.to_i)
    end

    def teacher_account
      @event.group.teacher.chat_account
    end

    def chat_team
      @event.group.chat_team
    end
  end
end
