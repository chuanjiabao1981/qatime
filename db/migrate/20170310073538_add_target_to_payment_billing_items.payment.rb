# This migration comes from payment (originally 20170310073443)
class AddTargetToPaymentBillingItems < ActiveRecord::Migration
  def change
    add_reference :payment_billing_items, :target, polymorphic: true
  end
end
