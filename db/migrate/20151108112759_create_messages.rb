class CreateMessages < ActiveRecord::Migration
  def change
    create_table :customized_course_messages do |t|
      t.integer :customized_course_message_board_id
      t.string  :title
      t.text    :content
      t.integer :author_id
      t.integer :customized_course_message_replies_count, default: 0
      t.integer :customized_course_id
      t.string  :token
      t.timestamps null: false
    end
  end
end
