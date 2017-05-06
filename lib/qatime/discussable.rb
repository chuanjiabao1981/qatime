module Qatime
  module Discussable
    extend ActiveSupport::Concern

    included do
      has_one :chat_team, class_name: 'Chat::Team', as: :discussable

      after_commit :instance_chat_team, on: :create
      def instance_chat_team(now = false)
        if now
          Chat::TeamCreatorJob.perform_later(model_name.name, id)
        else
          Chat::TeamCreatorJob.perform_now(model_name.name, id)
        end
      end
    end
  end
end
