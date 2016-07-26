# 每日任务 状态变更
task :lesson_status_changes => :environment do
  # 每天凌晨跑任务把当天init状态的课程切换为ready
  LiveService::LessonDirector.ready_today_lessons

  # 对于没能finished课程每天凌晨跑任务自动finished  昨天(包含)以前paused, closed转换为finished
  # 上课时间在前天(包括)以前并且状态为teaching的课程finish
  LiveService::LessonDirector.clean_lessons

  # 每天凌晨跑系统任务结算课程、finish状态下并且上课日期在前天(包括)以前的课程complete
  LiveService::LessonDirector.billing_lessons
end