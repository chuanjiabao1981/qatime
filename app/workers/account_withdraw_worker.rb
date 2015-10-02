class AccountWithdrawWorker

=begin
  此类负责将输入的老师帐号对应的未结账视频做结账
=end

  include Sidekiq::Worker
  sidekiq_options :queue => :account_withdraw, :retry => false, :backtrace => true

  ##输入老师id，将
  def perform(id)
    teacher = Teacher.find(id)
    teacher.withdraw
  end
end
