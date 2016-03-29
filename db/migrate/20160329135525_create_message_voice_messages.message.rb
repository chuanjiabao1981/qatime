# This migration comes from message (originally 20160329132935)
class CreateMessageVoiceMessages < ActiveRecord::Migration
  def change
    create_table :message_voice_messages do |t|

      t.timestamps null: false
    end
  end
end
