class CreateChatJoinRecords < ActiveRecord::Migration
  def change
    create_table :chat_join_records do |t|
      t.references :account, index: true
      t.references :team, index: true
      t.string :role, limit: 16

      t.timestamps null: false
    end
  end
end
