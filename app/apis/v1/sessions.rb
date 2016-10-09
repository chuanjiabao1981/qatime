module V1
  # 登录接口
  class Sessions < Base
    resource :sessions do
      desc 'User Signup.' do
      end
      params do
        optional :email, type: String, desc: '邮箱.'
        optional :login_account, type: String, desc: '登录帐号.'
        requires :password, type: String, desc: '密码.'
        requires :client_type, type: String, desc: '登陆方式.'
        requires :client_cate, type: String, values: %w(teacher_live student_client), desc: '客户端类型'
        exactly_one_of :email, :login_account
      end
      post do
        login_account = params[:login_account] || params[:email]
        user = login_account.include?("@") ? User.find_by(email: login_account) : User.find_by(login_mobile: login_account)
        client_type = params['client_type'].to_sym
        if user && user.authenticate(params[:password])
          # 判断客户端类型是否可以登陆
          soft = ::Software.published.where(category: ::Software.categories[params[:client_cate]]).last
          raise APIErrors::ClientInvalid unless soft.present? && soft.role == user.role
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
