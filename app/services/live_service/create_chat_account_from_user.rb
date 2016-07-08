module LiveService
  class CreateChatAccountFromUser

    def initialize(user)
      @user = user
    end

    def set_chat_account
      return if @user.chat_account.present?
      ::Chat::Account.create_by_user(@user)
    end

  end
end
