# This migration comes from payment (originally 20160930103735)
class CreatePaymentWithdrawRecords < ActiveRecord::Migration
  def change
    create_table :payment_withdraw_records do |t|
      t.belongs_to :payment_transaction
      t.string :account
      t.string :name
      t.integer :status
      t.timestamps null: false
    end
  end
end
