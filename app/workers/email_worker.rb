class EmailWorker
  CHANGE_EMAIL_CAPTCHA                 = :change_email_captcha

  include Sidekiq::Worker
  sidekiq_options :queue => :email, :retry => false, :backtrace => true

  def perform(notification_type,options={})
    UserMailer.send(notification_type, options).deliver
  end
end
