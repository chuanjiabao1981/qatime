module LiveService
  class EventDirector
    def initialize(event)
      @event = event
      @group = @event.group
    end

    # 开始直播
    def live_start(board, camera)
      # 第一节课开始上课之前把辅导班设置为已开课
      @group.teaching! if @group.published?
      LiveStudio::Event.transaction do
        @group.scheduled_lessons.waiting_close.where("id <> ?", @event.id).map(&:close!)
        @event.teach!
      end
      @event.record! # 设置录制
      LiveService::EventDirector.live_status_change(@group, board, camera, @event) # 更新直播状态
      @event.heartbeats(Time.now.to_i, ::LiveStudio::Event.beat_step)
    end

    # 直播心跳
    def heartbeats(t, step, token = nil)
      @event.heartbeats(t, step, token)
    end

    # 直播完成
    def finish
      @event.teacher_id = @group.teacher_id
      @event.live_count = @group.buy_tickets.count # 听课人数
      @event.live_end_at ||= Time.now
      @event.real_time = @event.live_sessions.sum(:duration) # 实际直播时间单位分钟
      @group.save!
      @event.finish!
    end

    # 直播状态更新
    def self.live_status_change(group, board, camera, event = nil)
      LiveService::GroupRealtimeService.new(group.id).update_live(event, board, camera)
      LiveService::GroupRealtimeService.update_lesson_live(event)
    end
  end
end
