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
    def lesson_start
      @course = @lesson.course
      # 如果辅导班已经有状态为teaching的课程,则返回false
      return false if !@course.lessons.teaching.blank?
      # 第一节课开始上课之前把辅导班设置为已开课
      @course.teaching! if @course.preview?
      LiveStudio::Lesson.transaction do
        # 记录上课开始时间
        @lesson.live_start_at = Time.now if @lesson.live_start_at.nil?
        # 开始上课之前把上一节未结束(pause, closed)的课程设置为结束(finished)，finished状态下的课程不能继续直播
        @course.lessons.waiting_finish.each do |lesson|
          lesson.finish! unless lesson.id == @lesson.id
        end
        @lesson.teach!
        @lesson.current_live_session
      end
    end

    # 准备上课
    # 上课时间为今天的设置为ready状态, init => ready
    def self.ready_today_lessons
      LiveStudio::Lesson.today.init.find_each(batch_size: 500).each do |lesson|
        lesson.ready!
        course = lesson.course
        if course.preview?
          course.teaching!
          LiveService::CourseNotificationSender.new(course).notice(:ready)
        end
      end
    end

    # 清理未完成课程
    # 1. 昨天(包括)以前paused, closed状态下的课程finish
    # 2. 上课时间在前天(包括)以前并且状态为teaching的课程finish
    def self.clean_lessons
      LiveStudio::Lesson.waiting_finish.where('class_date <= ?',Date.yesterday).find_each(batch_size: 500).map(&:finish!)
      LiveStudio::Lesson.teaching.where('class_date < ?', Date.yesterday).find_each(batch_size: 500).each do |lesson|
        lesson.close! && lesson.finish!
      end
    end

    # 结算课程
    # finish状态下并且上课日期在前天(包括)以前的课程complete
    def self.billing_lessons
      LiveStudio::Lesson.should_complete.each do |lesson|
        lesson.finished? && LiveService::BillingDirector.new(lesson).billing
        lesson.billing? && lesson.complete!
      end
    end

    # 暂停课程
    # teaching状态下10分钟没有收到心跳的课程
    def self.pause_lessons
      LiveStudio::Lesson.teaching.where("heartbeat_time < ?", 10.minutes.ago).map(&:pause!)
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
