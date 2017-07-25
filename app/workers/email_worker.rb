class EmailWorker
  CHANGE_EMAIL_CAPTCHA                 = :change_email_captcha
  GET_PASSWORD_BACK                    = :get_password_back

  # 上课通知
  LIVE_STUDIO_LESSON_START_NOTIFICATION = :live_studio_lesson_start

  include Sidekiq::Worker
  sidekiq_options :queue => :email, :retry => false, :backtrace => true

  def perform(notification_type, options = {})
    send(notification_type, options)
  end

  private

  def change_email_captcha(options)
    UserMailer.send(:change_email_captcha, options).deliver_now!
  end

  def get_password_back(options)
    UserMailer.send(:get_password_back, options).deliver_now!
  end

  def live_studio_lesson_start(options)
    # 没有邮件模板暂时不发邮件
    # NotificationMailer.send(:live_studio_lesson_start, options).deliver_now!
  end
end
