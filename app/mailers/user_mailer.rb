class UserMailer < ApplicationMailer
  default from: 'info@bjwwtd.com'

  def change_email_captcha(options)
    @captcha  = options["captcha"]
    send_to = options["email"]

    mail(to: send_to, subject: '绑定邮箱')
  end

  def get_password_back(options)
    @captcha  = options["captcha"]
    send_to = options["email"]
    mail(to: send_to, subject: '找回密码')
  end
end
