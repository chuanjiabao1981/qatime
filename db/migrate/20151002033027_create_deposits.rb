class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.integer :user_id
      t.float :value
      t.boolean :type

      t.timestamps null: false
    end
  end
end
