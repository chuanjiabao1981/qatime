module LiveService
  class ChatAccountFromUser

    def initialize(user)
      @user = user
    end

    def set_chat_account
      return if @user.chat_account.present?
      ::Chat::Account.create_by_user(@user)
    end

    def sync_uinfo
      return if @user.chat_account.blank?
      @user.chat_account.sync_uinfo
    end

  end
end
