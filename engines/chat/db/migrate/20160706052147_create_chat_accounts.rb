class CreateChatAccounts < ActiveRecord::Migration
  def change
    create_table :chat_accounts do |t|
      t.references :user, index: true

      t.string :accid, limit: 32
      t.string :token, limit: 32
      t.string :name, limit: 128
      t.string :icon

      t.timestamps null: false
    end
    add_index :chat_accounts, :user_id, unique: true, name: :chat_accounts_user_id_unique
  end
end
