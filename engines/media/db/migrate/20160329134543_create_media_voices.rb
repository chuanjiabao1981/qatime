class CreateMediaVoices < ActiveRecord::Migration
  def change
    create_table :media_voices do |t|
      t.references :voicable, polymorphic: true
      t.timestamps null: false
    end
  end
end
