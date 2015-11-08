class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :message_board_id
      t.string  :title
      t.text    :content
      t.integer :author_id
      t.integer :message_replies_count
      t.integer :customized_course_id
      t.string  :type
      t.string  :token
      t.timestamps null: false
    end
  end
end
