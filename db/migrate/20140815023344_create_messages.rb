class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :message_type
      t.string :status
      t.text :content

      t.timestamps
    end
  end
end
