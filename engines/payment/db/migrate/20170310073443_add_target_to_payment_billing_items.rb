class AddTargetToPaymentBillingItems < ActiveRecord::Migration
  def change
    add_reference :payment_billing_items, :target, polymorphic: true
  end
end
