class CreateChatAccounts < ActiveRecord::Migration
  def change
    create_table :chat_accounts do |t|
      t.references :user, index: true, unique: true

      t.string :accid, limit: 32
      t.string :token, limit: 32
      t.string :name, limit: 128
      t.string :icon

      t.timestamps null: false
    end
  end
end
