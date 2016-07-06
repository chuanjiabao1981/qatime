# This migration comes from chat (originally 20160706052147)
class CreateChatAccounts < ActiveRecord::Migration
  def change
    create_table :chat_accounts do |t|
      t.string :accid
      t.string :token
      t.string :username
      t.string :icon

      t.timestamps null: false
    end
  end
end
