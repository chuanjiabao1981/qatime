class CreateMessageBoards < ActiveRecord::Migration
  def change
    create_table :message_boards do |t|
      t.integer :messageboardable_id
      t.string  :messageboardable_type
      t.integer :messages_count,default: 0
      t.integer :message_replies_count,default: 0
      t.string  :type
      t.timestamps null: false
    end
  end
end
