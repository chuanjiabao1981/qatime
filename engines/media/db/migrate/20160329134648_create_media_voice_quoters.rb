class CreateMediaVoiceQuoters < ActiveRecord::Migration
  def change
    create_table :media_voice_quoters do |t|
      t.references :voice, index: true
      t.references :voice_message, index: true
      t.timestamps null: false
    end
  end
end
