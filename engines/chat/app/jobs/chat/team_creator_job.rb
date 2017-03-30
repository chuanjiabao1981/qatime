module Chat
  class TeamCreatorJob < ActiveJob::Base
    queue_as :chat

    def perform(discussable_type, discussable_id)
      discussable = discussable_type.constantize.find(discussable_id)
      LiveService::ChatTeamManager.new.instance_team(discussable)
    end
  end
end
