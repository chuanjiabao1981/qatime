# This migration comes from chat (originally 20160706052147)
class CreateChatAccounts < ActiveRecord::Migration
  def change
    create_table :chat_accounts do |t|
      t.references :user, index: true

      t.string :accid
      t.string :token
      t.string :name
      t.string :icon

      t.timestamps null: false
    end
  end
end
