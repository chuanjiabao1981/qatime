class UserMailer < ApplicationMailer
  default from: 'from@example.com'

  def send_captcha(user, captcha)
    @user = user
    @captcha  = captcha

    mail(to: @user.email, subject: '绑定邮箱')
  end
end
