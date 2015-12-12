class CreateConsumptionRecords < ActiveRecord::Migration
  def change
    create_table :consumption_records do |t|
      t.integer :fee_id
      t.integer :account_id
      t.float   :value
      t.timestamps null: false
    end
    remove_column :fees,:earning_account_id,:integer
    remove_column :fees,:consumption_account_id,:integer
  end
end
