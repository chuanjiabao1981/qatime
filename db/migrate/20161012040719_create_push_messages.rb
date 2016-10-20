class CreatePushMessages < ActiveRecord::Migration
  def change
    create_table :push_messages do |t|
      t.references :creator, polymorphic: true, index: true
      t.string :sign
      t.integer :push_type, index: true
      t.text :device_tokens
      t.integer :alias_type
      t.text :alias
      t.string :filter
      t.integer :display_type
      t.string :ticker
      t.string :title
      t.string :text
      t.integer :after_open
      t.string :url
      t.string :activity
      t.string :custom
      t.datetime :start_time
      t.datetime :expire_time
      t.string :out_biz_no
      t.string :production_mode
      t.integer :status
      t.text :result
      t.timestamps null: false
    end
  end
end
