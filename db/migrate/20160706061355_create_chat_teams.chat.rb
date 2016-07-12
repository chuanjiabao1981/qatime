# This migration comes from chat (originally 20160706055524)
class CreateChatTeams < ActiveRecord::Migration
  def change
    create_table :chat_teams do |t|
      t.string :team_id, limit: 32
      t.string :name, limit: 64
      t.references :live_studio_course, index: true
      t.string :owner, limit: 32
      t.text :announcement

      t.timestamps null: false
    end
  end
end
