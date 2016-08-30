module V1
  # 密码接口
  class Password < Base
    desc 'find password.'
    params do
      requires :login_account, type: String, desc: '登录账户'
      requires :captcha_confirmation, type: String, desc: '验证码'
      requires :password, type: String, desc: '新密码'
      requires :password_confirmation, type: String, desc: '密码确认'
    end
    put "password" do
      password_params = ActionController::Parameters.new(params).permit(:login_account, :password, :password_confirmation, :captcha_confirmation)

      user = User.find_by_login_account(password_params[:login_account]).try(:password_required!)
      if user
        captcha_manager = UserService::CaptchaManager.new(password_params[:login_account])
        user.captcha = captcha_manager.captcha_of(:get_password_back)
        if user.update_with_captcha(password_params)
          captcha_manager.expire_captch(:get_password_back)
          present user, with: Entities::User
        else
          raise(ActiveRecord::RecordInvalid.new(user))
        end
      end
    end
  end
end




