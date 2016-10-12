class CreateUserDevices < ActiveRecord::Migration
  def change
    create_table :user_devices do |t|
      t.belongs_to :user
      t.string :device_token
      t.timestamps null: false
    end
  end
end
