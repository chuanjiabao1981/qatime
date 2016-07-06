class CreateChatAccounts < ActiveRecord::Migration
  def change
    create_table :chat_accounts do |t|
      t.references :live_studio_course, index: true

      t.string :accid
      t.string :token
      t.string :username
      t.string :icon

      t.timestamps null: false
    end
  end
end
