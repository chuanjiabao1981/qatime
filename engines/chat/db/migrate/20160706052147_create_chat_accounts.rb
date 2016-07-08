class CreateChatAccounts < ActiveRecord::Migration
  def change
    create_table :chat_accounts do |t|
      t.references :live_studio_course, index: true

      t.string :accid, limit: 16, null: false
      t.string :token, limit: 32, null: false
      t.string :name, limit: 128
      t.string :icon

      t.timestamps null: false
    end
  end
end
