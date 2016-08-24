module V1
  # 注册接口
  class Register < Base
    resource :user do
      desc 'register.'
      params do
        requires :login_mobile, type: Integer, desc: '登录手机'
        requires :captcha_confirmation, type: String, desc: '手机验证码'
        requires :password, type: String, desc: '密码'
        requires :password_confirmation, type: String, desc: '密码确认'
        requires :register_code_value, type: String, desc: '注册码'
        requires :accept, type: String, desc: '接受服务协议'
        requires :type, type: Symbol, values: [:teacher, :student], desc: '注册用户类型'
        requires :client_type, type: String, desc: '登陆方式.'
      end

      post :register do
        client_type = params[:client_type].to_sym
        create_params = ActionController::Parameters.new(params).permit(:login_mobile, :captcha_confirmation, :password, :password_confirmation, :register_code_value, :accept)

        case params[:type]
        when :teacher
          user = Teacher.new(create_params).captcha_required!
        when :student
          user = Student.new(create_params).captcha_required!
        end

        captcha_manager = UserService::CaptchaManager.new(create_params[:login_mobile])
        user.captcha = captcha_manager.captcha_of(:register_captcha)
        user.build_account

        if user.save
          SmsWorker.perform_async(SmsWorker::REGISTRATION_NOTIFICATION, id: user.id)
          login_token = sign_in(user, client_type)
          present login_token, with: Entities::LoginToken
        else
          raise(ActiveRecord::RecordInvalid.new(user))
        end
      end
    end
  end
end
