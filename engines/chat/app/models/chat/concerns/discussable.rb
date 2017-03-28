module Chat
  module Discussable
    extend ActiveSupport::Concern

    included do
      has_one :chat_team, class_name: 'ChatTeam'

      after_commit :instance_chat_team, on: :create
      def instance_chat_team
        # TODO
        # 初始化聊天群组
      end
    end
  end
end
