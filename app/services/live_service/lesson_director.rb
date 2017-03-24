module LiveService
  class LessonDirector
    def initialize(lesson)
      @lesson = lesson
    end

    # 开始上课
    # 1. 有其它teaching状态的辅导班不可以开始直播
    # 2. 第一节课开始上课之前把辅导班设置为已开课
    # 3. 开始上课时间为空的初始化开始上课时间
    # 4. finish上一节课，为了避免漏处理  finish该辅导班内所有paused, closed状态的其它课程
    # 5. 开始本节课
    # 6. 初始化心跳
    def lesson_start(board, camera)
      @course = @lesson.course
      # 如果辅导班已经有状态为teaching的课程,则返回false
      return false unless @course.lessons.teaching.blank?
      # 第一节课开始上课之前把辅导班设置为已开课
      @course.teaching! if @course.published?
      LiveStudio::Lesson.transaction do
        # 记录上课开始时间
        @lesson.live_start_at = Time.now if @lesson.live_start_at.nil?
        # 开始上课之前把上一节未结束(pause, closed)的课程设置为结束(finished)，finished状态下的课程不能继续直播
        @course.lessons.waiting_finish.each do |lesson|
          LiveService::LessonDirector.new(lesson).finish unless lesson.id == @lesson.id
        end
        @lesson.teach!
        @lesson.current_live_session
      end
    ensure
      LiveService::LessonDirector.live_status_change(@lesson.course, board, camera, @lesson) if @lesson.teaching?
      LiveService::RealtimeService.update_lesson_live(@lesson)
    end

    def self.live_status_change(course, board, camera, lesson = nil)
      course.channels.board.last.update(live_status: board) rescue nil
      course.channels.camera.last.update(live_status: camera) rescue nil
    ensure
      LiveService::RealtimeService.new(course.id).update_live(lesson, board, camera)
      LiveService::RealtimeService.update_lesson_live(lesson)
    end

    # 完成课程
    def finish
      @course = @lesson.course
      @lesson.teacher_id = @course.teacher_id
      @lesson.live_count = @course.buy_tickets.count # 听课人数
      @lesson.live_end_at ||= Time.now
      @lesson.real_time = @lesson.live_sessions.sum(:duration) # 实际直播时间单位分钟
      @course.save!
      @lesson.finish!
      LiveService::RealtimeService.update_lesson_live(@lesson)
    end

    # 准备上课
    # 上课时间为今天的设置为ready状态, init => ready
    def self.ready_today_lessons
      LiveStudio::Lesson.today.init.includes(:course).find_each(batch_size: 500).each do |lesson|
        next unless lesson.course
        lesson.ready!
        lesson.course.teaching! if lesson.course.published?

        # 课程上课提醒，没有准确的定时任务的时候临时解决方案
        # 每天定时任务发送
        LiveService::LessonNotificationSender.new(lesson).notice(LiveStudioLessonNotification::ACTION_START_FOR_TEACHER)
        LiveService::LessonNotificationSender.new(lesson).notice(LiveStudioLessonNotification::ACTION_START_FOR_STUDENT)
        course = lesson.course
        if course.published?
          course.teaching!
          LiveService::CourseNotificationSender.new(course).notice(LiveStudioCourseNotification::ACTION_START)
        end
        LiveService::RealtimeService.update_lesson_live(lesson)
      end
    end

    # 清理未完成课程
    # 1. 昨天(包括)以前paused, closed状态下的课程finish
    # 2. 上课时间在前天(包括)以前并且状态为teaching的课程finish
    # 3. 错过的昨日课程发送通知
    def self.clean_lessons
      LiveStudio::Lesson.waiting_finish.where('class_date <= ?', Date.yesterday).find_each(batch_size: 500) do |l|
        next unless l.course
        l.close! if l.teaching? || l.paused?
        LiveService::LessonDirector.new(l).finish
      end
      LiveStudio::Lesson.teaching.where('class_date < ?', Date.yesterday).find_each(batch_size: 500).each do |lesson|
        next unless lesson.course
        lesson.close! if lesson.teaching? || lesson.paused?
        LiveService::LessonDirector.new(lesson).finish
      end

      # 未上课提示补课
      LiveStudio::Lesson.ready.where('class_date < ?', Date.today).find_each(batch_size: 500).each do |lesson|
        next unless lesson.course
        if lesson.ready? || lesson.init?
          lesson.miss!
          LiveService::LessonNotificationSender.new(lesson).notice(LiveStudioLessonNotification::ACTION_MISS_FOR_TEACHER)
        end
      end
    end

    # 结算课程
    # finish状态下并且上课日期在前天(包括)以前的课程complete
    def self.billing_lessons
      LiveStudio::Lesson.should_complete.each do |lesson|
        next unless lesson.course
        lesson.finished? && BusinessService::CourseBillingDirector.new(lesson).billing_lesson
        lesson.billing? && lesson.complete!
      end
    end

    # 暂停课程
    # teaching状态下10分钟没有收到心跳的课程
    def self.pause_lessons
      LiveStudio::Lesson.teaching.where("heartbeat_time < ?", 10.minutes.ago).each do |lesson|
        lesson.pause!
        LiveService::RealtimeService.update_lesson_live(lesson)
      end
    end

    # 编辑课程
    def self.edit_lessons(course, params)
      all_ids = course.lessons.map{|l| l.id.to_s}
      delete_ids = params[:delete_lesson_list].split(',')
      LiveStudio::Lesson.transaction do
        if all_ids.present?
          delete_ids.each do |id|
            LiveStudio::Lesson.find(id).destroy
          end
          (all_ids - delete_ids).each do |id|
            update_params = edit_lesson_params(id,params)
            lesson = LiveStudio::Lesson.find(id)
            _old_lesson_date = lesson.class_date.to_s + " " + lesson.live_time.to_s
            lesson.update(update_params)
            lesson.reload
            _new_lesson_date = lesson.class_date.to_s + " " + lesson.live_time.to_s
            # 如果没有name，则为调课，给学生发送调课消息
            if !update_params.has_key?(:name) && update_params[:class_date]
              course_action_record = course.course_action_records.new(
                content: I18n.t(
                  "activerecord.view.course_action_record.content.lesson_change_class_date_for_students",
                  lesson_name: lesson.name,
                  teacher_name: course.teacher.name,
                  old_lesson_date: _old_lesson_date,
                  new_lesson_date: _new_lesson_date
                ),
                category: :lesson_change_class_date_for_students,
                live_studio_course_id: course.id,
                live_studio_lesson_id: id
              )
              course_action_record.save(validate: false)
              LiveService::CourseActionRecordDirector.new(course_action_record).create_action_notification
            end
          end
        end
        create_lessons(course,params)
      end
    end

    private
    def self.create_lessons(course,params)
      params[:insert_lesson_list].split(',').map do |no|
        course.lessons.create(
          name: params["new_name_#{no}"],
          start_time: params["new_start_time_#{no}"],
          end_time: params["new_end_time_#{no}"],
          class_date: params["new_class_date_#{no}"]
        )
      end
    end

    def self.edit_lesson_params(id,params)
      h = {
            start_time: params["start_time_#{id}"],
            end_time: params["end_time_#{id}"],
            class_date: params["class_date_#{id}"]
          }

      if params["name_#{id}"].blank?
        if params["class_date_#{id}"] == Date.today.to_s
          h[:status] = :ready
        else
          h[:status] = :init
        end
      else
        h[:name] = params["name_#{id}"]
      end
      h
    end
  end
end
