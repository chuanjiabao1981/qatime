module Chat
  class TeamMemberCleanerJob < ActiveJob::Base
    queue_as :chat

    def perform(team_id, user_ids)
      @team = Chat::Team.find(team_id)
      LiveService::ChatTeamManager.new(@team).remove_members(user_ids)
    end
  end
end
