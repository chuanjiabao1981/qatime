# This migration comes from chat (originally 20170329052438)
class AddDiscussableToChatTeams < ActiveRecord::Migration
  def change
    add_reference :chat_teams, :discussable, polymorphic: true
  end
end
