class CreateMessageBoards < ActiveRecord::Migration
  def change
    create_table :customized_course_message_boards do |t|
      t.integer :customized_course_id
      t.integer :customized_course_messages_count,default: 0
      t.integer :customized_course_message_replies_count,default: 0
      t.timestamps null: false
    end
  end
end
