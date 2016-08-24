module V1
  # 验证码接口
  class Captcha < Base
    resource :captcha do
      desc 'create.'
      params do
        requires :send_to, type: String, desc: '发送对象'
        requires :key, type: Symbol, values: [:register_captcha, :send_captcha, :get_password_back, :change_email_captcha, :get_password_back], desc: '验证码用途'
      end

      post do
        unless UserService::CaptchaManager.new(params[:send_to]).generate_and_notice(params[:key])
          raise(Grape::Exceptions::ValidationErrors.new())
        end
      end
    end
  end
end
