# This migration comes from payment (originally 20160921023649)
class AddDeletedAtToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :deleted_at, :datetime
  end
end
