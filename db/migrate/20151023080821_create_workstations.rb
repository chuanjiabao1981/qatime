class CreateWorkstations < ActiveRecord::Migration
  def change
    create_table :workstations do |t|
      t.string :name
      t.integer :city_id
      t.string :address
      t.integer :tel
      t.string :email

      t.timestamps null: false
    end
  end
end
