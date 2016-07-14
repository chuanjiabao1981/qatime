module LiveService
  class ChatAccountFromUser
    def initialize(user)
      @user = user
    end

    def instance_account
      return if @user.chat_account.present?

      account_name = @user.nick_name || @user.name
      result_data = Chat::IM.account_create(random_accid, account_name, @user.avatar_url(:small))
      create_data = { name: account_name, icon: @user.avatar_url(:small) }

      @user.create_chat_account(create_data.merge(result_data))
    end

    # 更新同步网易云信名片
    def sync_chat_uinfo
      return if @user.chat_account.blank?

      chat_account = @user.chat_account
      account_name = @user.nick_name || @user.name

      # 更新获取网易云信名片
      Chat::IM.update_uinfo(chat_account.accid, account_name, @user.avatar_url(:small))
      uinfo = Chat::IM.get_uinfo(chat_account)

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
