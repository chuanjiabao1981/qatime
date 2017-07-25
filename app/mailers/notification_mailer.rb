class NotificationMailer < ApplicationMailer
  default from: 'info@bjwwtd.com'

  def live_studio_lesson_start(options)
    send_to = options["email"]

    # mail(to: send_to, subject: '直播开始')
  end
end
