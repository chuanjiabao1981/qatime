module V1
  # 登录接口
  class Sessions < Base
    resource :sessions do
      desc 'User Signup.' do
        headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
      end
      params do
        requires :email, type: String, desc: '邮箱.'
        requires :password, type: String, desc: '密码.'
      end
      post do
        user = User.where(email: params[:email]).first
        client_type = headers['Client-Type'].to_sym

        if user && user.authenticate(params[:password])
          sign_in(user, client_type)
          remember_token = user.login_tokens.where(client_type: LoginToken.client_types[client_type]).first.remember_token

          result = { remember_token: remember_token }
        else
          result = { error: "email or password error" }
        end

        result
      end

      desc 'User Signout.' do
        headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                },
                'Client-Type' => {
                  description: 'client_type',
                  required: true
                }
      end
      delete :destroy do
        sign_out
      end
    end
  end
end
