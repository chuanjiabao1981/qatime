module V1
  # 辅导班接口
  module Payment
    class CashAccounts < V1::Base
      namespace "payment" do
        before do
          authenticate!
        end
        resource :cash_accounts do
          desc '设置支付密码' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :ticket_token, type: String, desc: '验证token'
            requires :pament_password, type: String, desc: '支付密码'
          end
          post ':user_id/password' do
            cash_account = ::User.find(params[:user_id]).cash_account!
            password_params = { ticket_token: params[:ticket_token], password: params[:pament_password], password_set_at: Time.now}
            raise APIErrors::TokenInvalid, "授权Token无效" unless cash_account.update_with_token(:set_password, password_params)
            'ok'
          end

          desc '获取授权token' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            optional :current_pament_password, type: String, desc: '当前支付密码'
            optional :password, type: String, desc: '登陆密码'
            optional :captcha_confirmation, type: String, desc: '手机验证码'
          end
          post ':user_id/password/ticket_token' do
            cash_account = ::User.find(params[:user_id]).cash_account!
            if params[:current_pament_password].present?
              raise APIErrors::PasswordInvalid, "密码验证失败" unless cash_account.authenticate(params[:current_pament_password])
            else
              raise APIErrors::PasswordInvalid, "密码验证失败" unless current_user.authenticate(params[:password])
              captcha_manager = UserService::CaptchaManager.new(current_user.login_mobile)
              raise APIErrors::CaptchaError, "验证码不正确" unless captcha_manager.verify(:update_payment_pwd, params[:captcha_confirmation])
            end
            ::TicketToken.instance_token(cash_account, :set_password)
          end
        end
      end
    end
  end
end
