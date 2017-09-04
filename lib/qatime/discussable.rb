module Qatime
  module Discussable
    extend ActiveSupport::Concern

    included do
      has_one :chat_team, class_name: 'Chat::Team', as: :discussable

      after_commit :instance_chat_team, on: :create
      def instance_chat_team(now = false)
        if now
          Chat::TeamCreatorJob.perform_now(model_name.name, id)
        else
          Chat::TeamCreatorJob.perform_later(model_name.name, id)
        end
      end

      def async_instance_team
        Chat::TeamCreatorJob(perform_later(model_name.name, id))
      end

      def instance_team
        team_manager = LiveService::ChatTeamManager.new
        team_manager.instance_team(self)
        team_manager.add_users_to_team(members, 'owner')
      end

      # 成员
      def members
        teachers
      end
    end
  end
end
