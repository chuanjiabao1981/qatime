class DbBackupWorker

  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => false, :backtrace => true

  def perform
    dir = Rails.root
    Dir.chdir "#{ dir }/backup/" do
      Bundler.with_clean_env do
        # r=%x(bundle show)
        # BACKUP_ENV不是backup这个gem的参数，这个是自己定制的一个参数，传递给backup的module
        # 因为这个worker是通过
        # crontab 命令调用 lib/tasks/data_backup.rake 这个task启动的
        # 所以Rails.env是在crontab的命令中传递
        result = %x(BACKUP_ENV=#{Rails.env} rvm use ruby-2.2.1 do bundle exec backup perform -t db_backup -c ./backup_config.rb)
        if $?.exitstatus == 0
          # SmsWorker.perform_async(SmsWorker::NOTIFY, to: "管理员", message:"成功备份" ,mobile: "15910676326")
          # do no thing
        else
          SmsWorker.perform_async(SmsWorker::SYSTEM_ALARM, to: "管理员", error_message: "备份失败！！！！")
          raise StandardError,result
        end
      end
    end
    #   result = %x(pwd)
    # puts result
    # puts result
  end
end
