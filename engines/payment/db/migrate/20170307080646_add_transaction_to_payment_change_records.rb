class AddTransactionToPaymentChangeRecords < ActiveRecord::Migration
  def change
    add_reference :payment_change_records, :transaction, polymorphic: true
  end
end
