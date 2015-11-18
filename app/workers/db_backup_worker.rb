class DbBackupWorker


  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => false, :backtrace => true

  def perform
    sleep 10
  end
end
