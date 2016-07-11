module Chat
  class TeamMemberCreatorJob < ActiveJob::Base
    queue_as :chat

    def perform(course_id, user_id)
      @user = User.find(user_id)
      @chat_account = Chat::Account.find_by(user_id: @user.id)
      @chat_account ||= LiveService::ChatAccountFromUser.new(@user).instance_account

      @course = LiveStudio::Course.find(course_id)
      @team = @course.chat_team
      team_manager = LiveService::ChatTeamManager.new(@team)
      team_manager.instance_team(@course) if @team.nil?

      team_manager.add_to_team([@chat_account], 'normal')
    end
  end
end
