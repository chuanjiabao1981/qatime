class CreateChatTeams < ActiveRecord::Migration
  def change
    create_table :chat_teams do |t|
      t.string :team_id, limit: 32
      t.string :name, limit: 64
      t.references :live_studio_course, index: true, unique: true
      t.string :owner, limit: 32
      t.text :announcement

      t.timestamps null: false
    end
  end
end
