class AddBillingItemToPaymentChangeRecords < ActiveRecord::Migration
  def change
    add_reference :payment_change_records, :billing_item
  end
end
