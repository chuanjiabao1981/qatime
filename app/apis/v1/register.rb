module V1
  # 注册接口
  class Register < Base
    resource :user do
      desc 'get register code valid.'
      params do
        requires :type, type: String, values: ['Student'], desc: '注册用户类型'
      end
      get :register_code_valid do
        if Rails.env.testing? || Rails.env.test?
          RegisterCode.able_code.last.try(:value) || RegisterCode.batch_make("20", School.last)
          register_code_value = RegisterCode.able_code.last.value
          present register_code_value
        else
          raise(APIErrors::VersionOldError.new())
        end
      end

      desc 'register.'
      params do
        requires :login_mobile, type: Integer, desc: '登录手机'
        requires :captcha_confirmation, type: String, desc: '手机验证码'
        requires :password, type: String, desc: '密码'
        requires :password_confirmation, type: String, desc: '密码确认'
        requires :accept, type: String, desc: '接受服务协议'
        requires :type, type: String, values: ['Student'], desc: '注册用户类型'
        requires :client_type, type: String, desc: '登陆方式.'
      end
      post :register do
        client_type = params[:client_type].to_sym
        create_params_with_type = ActionController::Parameters.new(params).permit(:login_mobile, :captcha_confirmation, :password, :password_confirmation, :accept, :type)

        user = User.new(create_params_with_type).register_columns_required!.captcha_required!

        captcha_manager = UserService::CaptchaManager.new(create_params_with_type[:login_mobile])
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

      desc '微信注册.'
      params do
        requires :login_mobile, type: Integer, desc: '登录手机'
        requires :captcha_confirmation, type: String, desc: '手机验证码'
        requires :password, type: String, desc: '密码'
        requires :accept, type: String, desc: '接受服务协议'
        requires :type, type: String, values: ['Student'], desc: '注册用户类型'
        requires :client_type, type: String, desc: '登陆方式.'
        requires :grade, type: String, desc: '年级'
        requires :openid, type: String, desc: '微信openid'
        optional :province_id, type: Integer, desc: '省ID'
        optional :city_id, type: Integer, desc: '城市ID'
      end
      post :wechat_register do
        client_type = params[:client_type].to_sym
        create_params_with_type = ActionController::Parameters.new(params).permit(:login_mobile, :captcha_confirmation, :password, :accept, :type, :grade, :province_id, :city_id)
        user = User.new(create_params_with_type).register_columns_required!.captcha_required!
        captcha_manager = UserService::CaptchaManager.new(create_params_with_type[:login_mobile])
        user.captcha = captcha_manager.captcha_of(:register_captcha)
        user.build_account
        if user.save
          SmsWorker.perform_async(SmsWorker::REGISTRATION_NOTIFICATION, id: user.id)
          login_token = sign_in(user, client_type)
          UserService::WechatApi.binding_user(params[:openid], user, true)
          present login_token, with: Entities::LoginToken
        else
          raise(ActiveRecord::RecordInvalid.new(user))
        end
      end
    end
  end
end
