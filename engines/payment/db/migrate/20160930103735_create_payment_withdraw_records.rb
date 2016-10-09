class CreatePaymentWithdrawRecords < ActiveRecord::Migration
  def change
    create_table :payment_withdraw_records do |t|
      t.belongs_to :payment_transaction
      t.float :amount
      t.string :account
      t.string :name
      t.integer :status
      t.timestamps null: false
    end
  end
end
