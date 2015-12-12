class KeepAccountWorker

=begin
  此类负责将输入的老师帐号对应的未结账视频做结账
=end

  include Sidekiq::Worker
  sidekiq_options :queue => :keep_account, :retry => false, :backtrace => true

  ##输入老师id
  def perform(id)
    teacher = Teacher.find(id)
    teacher.keep_account
  end
end
