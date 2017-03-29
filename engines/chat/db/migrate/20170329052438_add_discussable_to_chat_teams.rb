class AddDiscussableToChatTeams < ActiveRecord::Migration
  def change
    add_reference :chat_teams, :discussable, polymorphic: true
  end
end
