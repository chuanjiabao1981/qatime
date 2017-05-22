module V1
  # 用户接口
  class Users < Base
    resource :users do
      before do
        authenticate!
      end

      helpers do
        def auth_params
          @user = ::User.find_by(id: params[:id])
        end
      end

      desc 'update email.' do
        headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
      end
      params do
        requires :id, type: Integer, desc: 'ID'
        requires :email, type: String, desc: '新邮箱'
        requires :captcha_confirmation, type: String, desc: '邮箱验证码'
      end
      put "/:id/email" do
        user = ::User.find(params[:id])
        email_params = ActionController::Parameters.new(params).permit(:email, :captcha_confirmation)

        captcha_manager = UserService::CaptchaManager.new(email_params[:email])
        user.captcha = captcha_manager.captcha_of(:change_email_captcha)

        if user.update_with_captcha(email_params)
          present user, with: Entities::User
        else
          raise(ActiveRecord::RecordInvalid.new(user))
        end
      end

      desc 'update login_mobile.' do
        headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
      end
      params do
        requires :id, type: Integer, desc: 'ID'
        requires :login_mobile, type: String, desc: '新手机号'
        requires :captcha_confirmation, type: String, desc: '手机验证码'
      end
      put "/:id/login_mobile" do
        user = ::User.find(params[:id])
        login_mobile_params = ActionController::Parameters.new(params).permit(:login_mobile, :captcha_confirmation)

        captcha_manager = UserService::CaptchaManager.new(login_mobile_params[:login_mobile])
        user.captcha = captcha_manager.captcha_of(:send_captcha)

        if user.update_with_captcha(login_mobile_params)
          present user, with: Entities::User
        else
          raise(ActiveRecord::RecordInvalid.new(user))
        end
      end

      desc 'update password.' do
        headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
      end
      params do
        requires :id, type: Integer, desc: 'ID'
        requires :current_password, type: String, desc: '旧密码'
        requires :password, type: String, desc: '新密码'
        requires :password_confirmation, type: String, desc: '密码确认'
      end
      put "/:id/password" do
        user = ::User.find(params[:id])
        password_params = ActionController::Parameters.new(params).permit(:current_password, :password, :password_confirmation)

        user.password_required!
        if user.update_with_password(password_params)
          present user, with: Entities::User
        else
          raise(ActiveRecord::RecordInvalid.new(user))
        end
      end

      desc '绑定微信' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      params do
        requires :id, type: Integer, desc: 'ID'
        optional :code, type: String, desc: '微信授权code'
        optional :openid, type: String, desc: '微信openid'
        exactly_one_of :code, :openid
      end
      post "/:id/wechat" do
        user = ::User.find(params[:id])
        wechat_user = if params[:openid].present?
                        Qawechat::WechatUser.find_by!(openid: params[:openid])
                      else
                        UserService::WechatApi.new(params[:code], 'app').web_access_token
                      end
        UserService::WechatApi.binding_user(wechat_user.openid, user)
        'ok'
      end

      desc '解绑微信' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      params do
        requires :id, type: Integer, desc: 'ID'
        requires :openid, type: String, desc: '微信openid'
      end
      delete "/:id/wechat" do
        user = ::User.find(params[:id])
        wechat_user = ::Qawechat::WechatUser.find_by(openid: params[:openid])
        if user == wechat_user.user
          wechat_user.update(user: nil)
        end
        'ok'
      end
    end
  end
end
