module UserService
  class PasswordVerifyManager
    def initialize(user)
      @user = user
    end

    # 检查登录密码
    def check_password(password)
      raise APIErrors::PasswordInvalid unless @user.authenticate(password)
    end

    # 验证token
    def check_token(cate, ticket_token)
      raise APIErrors::TokenInvalid unless ticket_token == ::TicketToken.get_instance_token(@user, cate)
    end
  end
end
