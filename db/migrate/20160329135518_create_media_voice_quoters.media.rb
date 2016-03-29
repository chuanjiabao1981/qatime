# This migration comes from media (originally 20160329134648)
class CreateMediaVoiceQuoters < ActiveRecord::Migration
  def change
    create_table :media_voice_quoters do |t|
      t.references :media_voice, index: true
      t.references :message_voice_message, index: true
      t.timestamps null: false
    end
  end
end
