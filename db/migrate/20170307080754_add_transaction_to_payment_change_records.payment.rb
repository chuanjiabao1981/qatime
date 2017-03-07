# This migration comes from payment (originally 20170307080646)
class AddTransactionToPaymentChangeRecords < ActiveRecord::Migration
  def change
    add_reference :payment_change_records, :transaction, polymorphic: true
  end
end
