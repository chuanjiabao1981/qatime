class DbBackupWorker


  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => false, :backtrace => true

  def perform
    dir = Rails.root
    Dir.chdir "#{ dir }/backup/" do

      Bundler.with_clean_env do
      # r=%x(bundle show)
      %x(AAA=3 bundle exec backup perform -t db_backup -c ./backup_config.rb)
      puts $?.exitstatus
      end
    end
    #   result = %x(pwd)
    # puts result
    # puts result
  end
end
