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
