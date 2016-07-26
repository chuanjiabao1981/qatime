# 每日任务 状态变更
task :lesson_status_changes => :environment do
  # 每天凌晨跑任务把当天init状态的课程切换为ready
  LiveService::LessonDirector.ready_today_lessons

  # 对于没能finished课程每天凌晨跑任务自动finished  昨天(包含)以前paused, closed转换为finished
  LiveStudio::Lesson.waiting_finish.where('class_date >= ?',Date.yesterday).each do |lesson|
    lesson.finish!
  end

  # 上课时间在前天(包括)以前并且状态为teaching的课程finish
  LiveStudio::Lesson.teaching.where('class_date > ?', Date.yesterday).each do |lesson|
    lesson.close! && lesson.finish!
  end

  #
  LiveStudio::Lesson.should_complete.each do |lesson|
    lesson.finished? && LiveService::BillingDirector.new(lesson).billing
    lesson.billing? && lesson.complete!
  end
end

# teaching状态的lesson 超过10分钟未收到心跳请求 自动转为pause
task :lesson_pause => :environment do
  LiveStudio::Lesson.teaching.includes(:live_sessions).each do |lesson|
    Time.now - lesson.live_sessions.last.heartbeat_at > 10*60 &&
        lesson.pause!
  end
end
