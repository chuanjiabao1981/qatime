# This migration comes from payment (originally 20161025063055)
class AddParentIdToPaymentBillings < ActiveRecord::Migration
  def change
    add_column :payment_billings, :parent_id, :integer, index: true
  end
end
