module UserService
  class CashAccountManager
    def initialize(user)
      @user = user
      @cash_account = user.cash_account!
    end

    # 检查支付密码
    def check_password(password)
      raise APIErrors::PaymentPasswordBlank if @cash_account.password_set_at.blank?
      raise APIErrors::PasswordDissatisfy if @cash_account.password_set_at > 2.hours.ago
      raise APIErrors::PasswordInvalid unless @cash_account.authenticate(password)
    end

    # 验证token
    def check_token(cate, ticket_token)
      raise APIErrors::TokenInvalid unless ticket_token == Redis.current.get("#{@cash_account.model_name.cache_key}/#{@cash_account.id}/#{cate}")
    end
  end
end
