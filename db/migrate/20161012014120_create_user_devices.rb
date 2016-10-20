class CreateUserDevices < ActiveRecord::Migration
  def change
    create_table :user_devices do |t|
      t.belongs_to :user
      t.string :model
      t.string :token
      t.string :app_name
      t.string :app_version
      t.timestamps null: false
    end
  end
end
