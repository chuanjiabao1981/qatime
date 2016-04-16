# This migration comes from message (originally 20160416005946)
class CreateMessageImages < ActiveRecord::Migration
  def change
    create_table :message_images do |t|
      t.string :name
      t.references :imagable, :polymorphic => true
      t.timestamps null: false
    end
  end
end
