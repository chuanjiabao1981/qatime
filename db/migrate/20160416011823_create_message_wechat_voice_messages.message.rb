# This migration comes from message (originally 20160416005921)
class CreateMessageWechatVoiceMessages < ActiveRecord::Migration
  def change
    create_table :message_wechat_voice_messages do |t|
      t.string :name
      t.integer :duration
      t.string :state
      t.integer :author_id
      t.integer :last_operator_id
      t.timestamps null: false
    end
  end
end
