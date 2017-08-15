module LiveService
  class InteractiveLessonDirector
    def initialize(lesson)
      @lesson = lesson
    end

    # 开始上课
    # 1. 设置上课中和暂停中的其它课程关闭
    # 2. 第一节课开始上课之前把辅导班设置为已开课
    # 3. 开始上课时间为空的初始化开始上课时间
    # 4. 开始本节课
    # 5. 初始化心跳
    def lesson_start(board, camera, room_id = nil, channel_id = nil)
      @course = @lesson.interactive_course
      @course.teaching! if @course.published?
      LiveStudio::InteractiveLesson.transaction do
        @course.interactive_lessons.where(status: LiveStudio::InteractiveLesson.statuses.values_at(:paused, :teaching)).where("id <> ?", @lesson.id).each do |l|
          l.close!
          LiveService::InteractiveLessonDirector.live_status_change(@course, 0, 0, l)
        end
        # 记录上课开始时间
        @lesson.live_start_at = Time.now if @lesson.live_start_at.nil?
        @lesson.room_id = room_id
        @lesson.description = [@lesson.description, channel_id.to_s].join('__')
        @lesson.teach!
        @lesson.current_live_session
      end
    ensure
      LiveService::InteractiveLessonDirector.live_status_change(@course, board, camera, @lesson) if @lesson.teaching?
      LiveService::InteractiveRealtimeService.update_lesson_live(@lesson)
    end

    def self.live_status_change(course, board, camera, lesson = nil)
      LiveService::InteractiveRealtimeService.new(course.id).update_live(lesson, board, camera)
      LiveService::InteractiveRealtimeService.update_lesson_live(lesson)
    end

    # 完成课程
    def finish
      @course = @lesson.interactive_course
      @lesson.live_count = @course.buy_tickets.count # 听课人数
      @lesson.live_end_at ||= Time.now
      @lesson.real_time = @lesson.live_sessions.sum(:duration) # 实际直播时间单位分钟
      @course.save!
      @lesson.finish!
      LiveService::InteractiveRealtimeService.update_lesson_live(@lesson)
    end

    # 准备上课
    # 上课时间为今天的设置为ready状态, init => ready
    def self.ready_today_lessons
      LiveStudio::InteractiveLesson.today.init.includes(:interactive_course).find_each(batch_size: 50).each do |lesson|
        next unless lesson.interactive_course # course被删除以后lesson不处理
        next unless lesson.interactive_course.teaching? # 没人购买今天的课程不处理
        lesson.ready!
        course = lesson.interactive_course
        course.teaching! if course.published?
        LiveService::InteractiveRealtimeService.update_lesson_live(lesson)
      end
    end

    # 清理未完成课程
    # 1. 昨天(包括)以前paused, closed状态下的课程finish
    # 2. 上课时间在前天(包括)以前并且状态为teaching的课程finish
    # 3. 错过的昨日课程发送通知
    def self.clean_lessons
      LiveStudio::InteractiveLesson.waiting_finish.where('class_date <= ?', Date.today).find_each(batch_size: 50) do |l|
        next unless l.interactive_course
        l.close! if l.paused?
        LiveService::InteractiveLessonDirector.new(l).finish
      end
      LiveStudio::InteractiveLesson.teaching.where('class_date < ?', Date.today).find_each(batch_size: 500).each do |lesson|
        next unless lesson.interactive_course
        lesson.close! if lesson.paused?
        LiveService::InteractiveLessonDirector.new(lesson).finish
      end

      # 未上课提示补课
      LiveStudio::InteractiveLesson.ready.where('class_date < ?', Date.today).find_each(batch_size: 500).each do |lesson|
        next unless lesson.interactive_course
        if lesson.ready? || lesson.init?
          lesson.miss!
        end
      end
    end

    # 结算课程
    # finish状态下并且上课日期在前天(包括)以前的课程complete
    def self.billing_lessons
      LiveStudio::InteractiveLesson.should_complete.each do |lesson|
        next unless lesson.interactive_course
        lesson.finished? && BusinessService::InteractiveCourseBillingDirector.new(lesson).billing_lesson
        lesson.billing? && lesson.complete!
      end
    end

    # 暂停课程
    # teaching状态下10分钟没有收到心跳的课程
    def self.pause_lessons
      LiveStudio::InteractiveLesson.teaching.where("heartbeat_time < ?", 10.minutes.ago).each do |lesson|
        lesson.pause!
        LiveService::InteractiveRealtimeService.update_lesson_live(lesson)
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
