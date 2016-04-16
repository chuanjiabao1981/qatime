# This migration comes from message (originally 20160416005938)
class CreateMessageImageMessages < ActiveRecord::Migration
  def change
    create_table :message_image_messages do |t|
      t.integer :count
      t.integer :author_id
      t.integer :last_operator_id
      t.timestamps null: false
    end
  end
end
