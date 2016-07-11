module Chat
  class TeamMemberCreatorJob < ActiveJob::Base
    queue_as :chat

    def perform(team_id, user_id)
      @user = User.find(user_id)
      @team = Chat::Team.find(team_id)
      @chat_account = ChatAccount.find_by(user_id: user_id)
      @chat_account ||= LiveService::ChatAccountFromUser.new(user).instance_account
      LiveService::ChatTeamManager.new(@team).add_to_team(@team, [@chat_account], 'normal')
    end
  end
end
