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
        # 记录上课开始时间
        @event.live_start_at = Time.now if @event.live_start_at.nil?
        @event.teach! if @event.can_live?
      end
      @event.record! # 设置录制
      LiveService::EventDirector.live_status_change(@group, board, camera, @event) # 更新直播状态
      @event.heartbeats(Time.now.to_i, ::LiveStudio::Group.beat_step)
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

    # 准备上课
    # 上课时间为今天的设置为ready状态, init => ready
    def self.ready_today_lessons
      LiveStudio::Event.scheduled_and_offline_lessons.today.init.includes(:group).find_each(batch_size: 500).each do |lesson|
        next unless lesson.group
        lesson.ready!
        lesson.group.teaching! if lesson.group.published?

        # 课程上课提醒，没有准确的定时任务的时候临时解决方案
        # 每天定时任务发送
        # TODO 消息通知
        # LiveService::LessonNotificationSender.new(lesson).notice(LiveStudioLessonNotification::ACTION_START_FOR_TEACHER)
        # LiveService::LessonNotificationSender.new(lesson).notice(LiveStudioLessonNotification::ACTION_START_FOR_STUDENT)
        group = lesson.group
        if group.published?
          group.teaching!
          # LiveService::CourseNotificationSender.new(group).notice(LiveStudioCourseNotification::ACTION_START)
        end
        LiveService::GroupRealtimeService.update_lesson_live(lesson)
      end
    end

    # 清理未完成课程
    # 1. 昨天(包括)以前paused, closed状态下的课程finish
    # 2. 上课时间在前天(包括)以前并且状态为teaching的课程finish
    # 3. 错过的昨日课程发送通知
    def self.clean_lessons
      LiveStudio::ScheduledLesson.waiting_finish.where('class_date <= ?', Date.yesterday).find_each(batch_size: 500) do |l|
        next unless l.group
        l.close! if l.teaching? || l.paused?
        LiveService::EventDirector.new(l).finish
      end
      LiveStudio::ScheduledLesson.teaching.where('class_date < ?', Date.yesterday).find_each(batch_size: 500).each do |lesson|
        next unless lesson.group
        lesson.close! if lesson.teaching? || lesson.paused?
        LiveService::EventDirector.new(lesson).finish
      end

      # 未上课提示补课
      LiveStudio::ScheduledLesson.ready.where('class_date < ?', Date.today).find_each(batch_size: 500).each do |lesson|
        next unless lesson.group
        if lesson.ready? || lesson.init?
          lesson.miss!
          # LiveService::LessonNotificationSender.new(lesson).notice(LiveStudioLessonNotification::ACTION_MISS_FOR_TEACHER)
        end
      end
    end

    # 暂停课程
    # teaching状态下10分钟没有收到心跳的课程
    def self.pause_lessons
      LiveStudio::ScheduledLesson.teaching.where("heartbeat_time < ?", 10.minutes.ago).each do |lesson|
        lesson.close!
        LiveService::GroupRealtimeService.update_lesson_live(lesson)
      end
    end
  end
end
