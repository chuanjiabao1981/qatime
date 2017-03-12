# This migration comes from payment (originally 20170310091052)
class AddAssessBillingIdToPaymentChangeRecords < ActiveRecord::Migration
  def change
    add_column :payment_change_records, :assess_billing_id, :integer, index: true
  end
end
