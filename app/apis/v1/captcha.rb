module V1
  # 验证码接口
  class Captcha < Base
    resource :captcha do
      desc 'create.'
      params do
        requires :send_to, type: String, desc: '发送对象'
        requires :key, type: Symbol, values: [:register_captcha, :send_captcha, :get_password_back, :change_email_captcha, :withdraw_cash], desc: '验证码用途'
      end

      post do
        unless UserService::CaptchaManager.new(params[:send_to]).generate_and_notice(params[:key])
          { result: 'failed', error: "params error" }
        end
      end

      desc 'verify.'
      params do
        requires :send_to, type: String, desc: '发送对象'
        requires :captcha, type: String, desc: '验证码'
        # requires :by, type: String, values: %w(email login_mobile parent_phone change_email_captcha get_password_back), desc: '验证用途'
      end

      post :verify do
        send_to = params[:send_to]
        captcha_manager = UserService::CaptchaManager.new(send_to)
        captcha = captcha_manager.captcha_of(:send_captcha)
        unless params[:captcha] == captcha
          { result: 'failed', error: "captcha error" }
        end
      end
    end
  end
end
