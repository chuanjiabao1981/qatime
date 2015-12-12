class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string  :type
      t.integer :receiver_id
      t.string  :notificationable_type
      t.integer :notificationable_id
      t.integer :operator_id
      t.boolean :read,default: false
      t.string  :action_name
      t.timestamps null: false
    end
  end
end
