module Qatime
  module Discussable
    extend ActiveSupport::Concern

    included do
      has_one :chat_team, class_name: 'Chat::Team', as: :discussable

      after_commit :instance_chat_team, on: :create
      def instance_chat_team
        Chat::TeamCreatorJob.perform_later(model_name.name, id)
      end
    end
  end
end
