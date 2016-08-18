module V1
  # 登录接口
  class Sessions < Base
    resource :sessions do
      desc 'User Signup.' do
      end
      params do
        optional :email, type: String, desc: '邮箱.'
        optional :login_mobile, type: String, desc: '登录手机号.'
        requires :password, type: String, desc: '密码.'
        requires :client_type, type: String, desc: '登陆方式.'
        exactly_one_of :email, :login_mobile
      end
      post do
        login_account = params[:login_mobile] || params[:email]
        user = login_account.include?("@") ? User.find_by(email: login_account) : User.find_by(login_mobile: login_account)
        client_type = params['client_type']

        if user && user.authenticate(params[:password])
          login_token = sign_in(user, client_type)
          present login_token, with: Entities::LoginToken
        else
          { result: 'failed', error: "email or password error" }
        end
      end

      desc 'User Signout.' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      delete do
        sign_out
      end
    end
  end
end
