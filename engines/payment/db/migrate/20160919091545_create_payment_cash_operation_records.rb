class CreatePaymentCashOperationRecords < ActiveRecord::Migration
  def change
    create_table :payment_cash_operation_records do |t|
      t.integer :operator_id
      t.integer :account_id
      t.float :value
      t.string :type
      t.timestamps null: false
    end

    Withdraw.find_each(:batch_size => 1000) do |w|
      Payment::CashOperationRecord.create(
        operator_id: w.operator_id,
        account_id: w.account_id,
        value: w.value,
        type: w.type
      )
    end
  end
end
