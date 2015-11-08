class CreateMessageReplies < ActiveRecord::Migration
  def change
    create_table :message_replies do |t|
      t.integer :message_id
      t.integer :message_board_id
      t.integer :customized_course_id
      t.text    :content
      t.string  :token
      t.string  :type
      t.integer :author_id
      t.timestamps null: false
    end
  end
end
