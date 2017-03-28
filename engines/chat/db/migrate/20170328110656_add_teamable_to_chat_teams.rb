class AddTeamableToChatTeams < ActiveRecord::Migration
  def change
    add_reference :chat_teams, :teamable, polymorphic: true
  end
end
