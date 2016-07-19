module V1
  # 系统环境
  class Sessions < Base
    resource :sessions do
      desc 'User Signup.'
      params do
        requires :email, type: String, desc: '邮箱.'
        requires :password, type: String, desc: '密码.'
        requires :client_type, type: String, values: %w{pc web app}, desc: '客户端类型'
      end
      post do
        user = User.where(email: params[:email]).first
        client_type = params[:client_type].to_sym

        if user && user.authenticate(params[:password])
          sign_in(user, client_type)
          remember_token = user.login_tokens.where(client_type: client_type).first.remember_token
          result = { remember_token: remember_token }
        else
          result = { error: "email or password error" }
        end

        result
      end
    end
  end
end
