# This migration comes from chat (originally 20160706055524)
class CreateChatTeams < ActiveRecord::Migration
  def change
    create_table :chat_teams do |t|
      t.string :team_id
      t.text :announcement
      t.string :name

      t.timestamps null: false
    end
  end
end
