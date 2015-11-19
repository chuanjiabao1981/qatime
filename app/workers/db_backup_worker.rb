class DbBackupWorker


  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => false, :backtrace => true

  def perform
    dir = Rails.root
    Dir.chdir "#{ dir }/backup/" do
      Bundler.with_clean_env do
      # r=%x(bundle show)
      %x(bundle exec backup perform -t db_backup)
      puts $?.exitstatus
      end
    end
    #   result = %x(pwd)
    # puts result
    # puts result
  end
end
