class CreateMessageMessages < ActiveRecord::Migration
  def change
    create_table :message_messages do |t|
      t.references :messagable, :polymorphic => true
      t.references :implementable, :polymorphic => true
      t.timestamps null: false
    end
  end
end
