require 'encryption'

module LiveService
  class ChatAccountFromUser
    def initialize(user)
      @user = user
    end

    def instance_account(force = false)
      chat_account = find_or_create_chat_account
      return chat_account if !force && chat_account.token
      result_data = Chat::IM.account_create(chat_account.accid, chat_account.name, chat_account.icon, chat_account.token)
      raise '聊天账户创建失败' unless result_data
      chat_account.update_attributes(result_data.slice('token', 'accid', 'name').compact)
      chat_account
    end

    # 更新同步网易云信名片
    def sync_chat_uinfo
      return if @user.chat_account.blank?

      chat_account = @user.chat_account
      account_name = @user.nick_name || @user.name

      # 更新获取网易云信名片
      Chat::IM.update_uinfo(chat_account.accid, account_name, @user.avatar_url(:small))
      uinfo = Chat::IM.get_uinfo(chat_account.accid)

      chat_account.update_columns(uinfo.merge("icon" => @user.avatar_url(:small)))
    end

    def init_account_for_live
      # 初始化
    end

    private

    def encryption_accid
      Encryption.md5("#{Rails.env}-#{@user.id}")
    end

    def find_or_create_chat_account
      return @user.chat_account if @user.chat_account
      account_name = @user.nick_name || @user.name
      @user.create_chat_account(name: account_name, icon: @user.avatar_url(:small), accid: encryption_accid)
    rescue ActiveRecord::RecordNotUnique
      @user.reload
      retry
    end
  end
end
