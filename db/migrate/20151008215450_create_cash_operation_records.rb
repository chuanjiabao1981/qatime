class CreateCashOperationRecords < ActiveRecord::Migration
  def change
    create_table :cash_operation_records do |t|
      t.integer :operator_id
      t.integer :account_id
      t.float   :value
      t.integer :op_type
      t.timestamps null: false
    end
  end
end
