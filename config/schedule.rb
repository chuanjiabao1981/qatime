# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
# 由于自带的rake job_type 会增加一个silent的参数，此参数在development会报错
job_type :rake_m,    "cd :path && :environment_variable=:environment :bundle_command rake :task :output"

# environment = :development
set :environment, :development
set :output, "#{Whenever.path}/log/cron.log"


##注意这里一定写明要roles，就是哪些机器上运行
every 4.hours , :roles => [:db] do
  rake_m 'data_backup:db'
end

# 每天凌晨1点把今天将要上课的课程设为ready状态
every 1.day, :at => '1:00 am', :roles => [:web] do
  runner "LiveService::LessonDirector.ready_today_lessons"
  runner "LiveService::InteractiveLessonDirector.ready_today_lessons"
end

# 每天凌晨1点30分清理未完成的课程
every 1.day, :at => '1:30 am', :roles => [:web] do
  runner "LiveService::LessonDirector.clean_lessons"
  runner "LiveService::InteractiveLessonDirector.clean_lessons"
end

# 每天凌晨2点结算已完成的课程
every 1.day, :at => '2:00 am', :roles => [:web] do
  runner "LiveService::LessonDirector.billing_lessons"
  runner "LiveService::InteractiveLessonDirector.billing_lessons"
end

# 每天凌晨3点清理全部完成的辅导班
every 1.day, :at => '3:00 am', :roles => [:web] do
  runner "LiveService::CourseDirector.clean_courses"
  runner "LiveService::InteractiveCourseDirector.clean_courses"
end

# 五分钟执行一次,判断是否有teaching状态的课程已离线
every 5.minutes do
  runner "LessonPauseWorker.perform_async"
end

# 每天处理考核任务
every 1.day, :at => '00:30 am', :roles => [:web] do
  runner "BusinessService::TaskBillingDirector.handle_tasks"
end
