module LiveService
  class ChatAccountFromUser
    def initialize(user)
      @user = user
    end

    def instance_account
      result = ::Chat::IM.user_create(accid: random_accid, name: @user.nick_name, icon: @user.avatar_url(:tiny))
      ::Chat::Account.create(user: @user, accid: result['accid'], token: result['token'], name: @user.nick_name, icon: @user.avatar_url(:tiny))
    end

    def set_chat_account
      return if @user.chat_account.present?
      ::Chat::Account.create_by_user(@user)
    end

    def sync_chat_uinfo
      return if @user.chat_account.blank?
      @user.chat_account.sync_uinfo
    end

    def init_account_for_live
      # 初始化
    end

    private

    def random_accid
      SecureRandom.hex(16)
    end
  end
end
