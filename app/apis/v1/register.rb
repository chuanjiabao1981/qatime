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
        requires :type, type: String, values: %w(Student Teacher), desc: '注册用户类型'
        requires :client_type, type: String, desc: '登陆方式.', values: %w(pc app)
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

      desc '检测用户存在'
      params do
        requires :account, type: String, desc: '登陆账户'
      end
      get '/check' do
        User.find_by(login_mobile: params[:account]).present? || User.find_by(email: params[:account]).present?
      end

      desc '创建游客账户'
      params do
        requires :password, type: String, desc: '登陆密码'
        requires :password_confirmation, type: String, desc: '密码确认'
      end
      post 'guests' do
        student = Student.create(password: params[:password], password_confirmation: params[:password_confirmation], is_guest: true)
        raise(ActiveRecord::RecordInvalid, student) unless student.update(name: student.id)
        student.use_default_avatar unless student.avatar.present?
        login_token = sign_in(student, 'app')
        present login_token, with: Entities::LoginToken
      end

      namespace :guests do
        before do
          authenticate!
        end
        route_param :id do
          desc '游客绑定' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :login_mobile, type: Integer, desc: '登录手机'
            requires :captcha_confirmation, type: String, desc: '手机验证码'
            requires :password, type: String, desc: '密码'
            requires :password_confirmation, type: String, desc: '密码确认'
            requires :accept, type: String, desc: '接受服务协议'
            requires :name, type: String, desc: '姓名'
          end
          post 'bind' do
            user = current_user
            user.register_columns_required!.captcha_required!
            bind_params_with_type = ActionController::Parameters.new(params).permit(:login_mobile, :name, :captcha_confirmation, :password, :password_confirmation, :accept)
            bind_params_with_type[:is_guest] = false
            captcha_manager = UserService::CaptchaManager.new(bind_params_with_type[:login_mobile])
            user.captcha = captcha_manager.captcha_of(:register_captcha)
            raise ActiveRecord::RecordInvalid, user unless user.update(bind_params_with_type)
            SmsWorker.perform_async(SmsWorker::REGISTRATION_NOTIFICATION, id: user.id)
            login_token = sign_in(user, 'app')
            present login_token, with: Entities::LoginToken
          end
        end
      end
    end
  end
end
