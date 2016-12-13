module V1
  # 用户接口
  class TicketTokens < Base
    resource :ticket_tokens do
      before do
        authenticate!
      end

      desc '获取重置支付密码的token' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      params do
        requires :id, type: Integer, desc: '资金账户ID'
        requires :password, type: String, desc: '登陆密码'
        requires :captcha_confirmation, type: String, desc: '手机验证码'
      end
      post 'cash_accounts/update_password' do
        cash_account = current_user.cash_account!
        raise APIErrors::PasswordInvalid, "密码验证失败" unless current_user.validate(params[:password])
        captcha_manager = UserService::CaptchaManager.new(current_user.login_mobile)
        raise APIErrors::CaptchaError, "验证码不正确" unless captcha_manager.verify(:update_payment_pwd, params[:captcha_confirmation])
        ::TicketToken.instance_token(cash_account, :update_password)
      end
    end
  end
end
