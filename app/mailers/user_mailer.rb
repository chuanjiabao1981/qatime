class UserMailer < ApplicationMailer
  default from: 'from@example.com'

  def change_email_captcha(send_to, captcha)
    @captcha  = captcha

    mail(to: send_to, subject: '绑定邮箱')
  end
end
