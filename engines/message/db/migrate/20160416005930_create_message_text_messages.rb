class CreateMessageTextMessages < ActiveRecord::Migration
  def change
    create_table :message_text_messages do |t|
      t.text :content
      t.integer :author_id
      t.integer :last_operator_id
      t.timestamps null: false
    end
  end
end
