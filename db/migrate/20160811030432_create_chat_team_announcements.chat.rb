# This migration comes from chat (originally 20160810132218)
class CreateChatTeamAnnouncements < ActiveRecord::Migration
  def change
    create_table :chat_team_announcements do |t|
      t.references :team
      t.text :announcement
      t.datetime :edit_at
      t.timestamps null: false
    end
    remove_column :chat_teams, :announcement, :text
  end
end
