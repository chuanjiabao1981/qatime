# This migration comes from payment (originally 20170307020052)
class AddBillingItemToPaymentChangeRecords < ActiveRecord::Migration
  def change
    add_reference :payment_change_records, :billing_item
  end
end
