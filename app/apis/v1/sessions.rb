module V1
  # 系统环境
  class Sessions < Grape::API
    resource :sessions do
      desc 'User Signup.'
      params do
        requires :email, type: String, desc: '邮箱.'
        requires :password, type: String, desc: '密码.'
      end
      post do
        "OK"
      end
    end
  end
end
