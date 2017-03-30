module Chat
  class TeamMemberCreatorJob < ActiveJob::Base
    queue_as :chat

    def perform(team_id, user_id)
      @user = User.find(user_id)
      @chat_account = Chat::Account.find_by(user_id: @user.id)
      @chat_account ||= LiveService::ChatAccountFromUser.new(@user).instance_account

      @course = LiveStudio::Course.find(course_id)
      @team = Chat::Team.find(team_id)
      LiveService::ChatTeamManager.new(@team).add_to_team([@chat_account], 'normal')
    end
  end
end
