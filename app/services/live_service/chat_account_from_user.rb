module LiveService
  class ChatAccountFromUser
    def initialize(user)
      @user = user
    end

    def instance_account
      result_data = Chat::IM.account_create(accid: "#{random_accid}", name: "#{@user.nick_name}", icon: "#{@user.avatar_url(:tiny)}")
      chat_account = @user.create_chat_account(result_data)

      uinfo = Chat::IM.get_uinfo(chat_account)
      chat_account.update_columns(uinfo)
    end

    def set_chat_account
      return if @user.chat_account.present?
      instance_chat_account
    end

    # 更新同步网易云信名片
    def sync_chat_uinfo
      return if @user.chat_account.blank?

      # 更新获取网易云信名片
      chat_account = @user.chat_account
      Chat::IM.update_uinfo(chat_account)
      uinfo = Chat::IM.get_uinfo(.chat_account)

      chat_account.update_columns(uinfo)
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
