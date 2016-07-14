module Chat
  class SyncChatAccountJob < ActiveJob::Base
    queue_as :chat

    def perform(user_id)
      @user = ::User.find(user_id)
      LiveService::ChatAccountFromUser.new(@user).sync_chat_uinfo
    end
  end
end
