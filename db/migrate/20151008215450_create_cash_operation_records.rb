class CreateCashOperationRecords < ActiveRecord::Migration
  def change
    create_table :cash_operation_records do |t|
      t.integer :operator_id
      t.integer :account_id
      t.float   :value
      t.string :type
      t.timestamps null: false
    end
    drop_table :deposits
  end
end
