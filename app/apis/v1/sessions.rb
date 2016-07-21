module V1
  # 登录接口
  class Sessions < Base
    resource :sessions do
      desc 'User Signup.' do
      end
      params do
        requires :email, type: String, desc: '邮箱.'
        requires :password, type: String, desc: '密码.'
        requires :client_type, type: String, desc: '登陆方式.'
      end
      post do
        user = User.where(email: params[:email]).first
        client_type = params['client_type']

        if user && user.authenticate(params[:password])
          login_token = sign_in(user, client_type)
          present login_token, with: API::Entities::LoginToken
        else
          { error: "email or password error" }
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
