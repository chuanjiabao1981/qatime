class CreateMessageReplies < ActiveRecord::Migration
  def change
    create_table :customized_course_message_replies do |t|
      t.integer :customized_course_message_id
      t.integer :customized_course_message_board_id
      t.integer :customized_course_id
      t.text    :content
      t.string  :token
      t.integer :author_id
      t.timestamps null: false
    end
  end
end
