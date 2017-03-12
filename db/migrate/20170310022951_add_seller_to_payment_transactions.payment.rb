# This migration comes from payment (originally 20170310022723)
class AddSellerToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :seller_id, :integer
    add_column :payment_transactions, :seller_type, :string

    add_index :payment_transactions, [:seller_id, :seller_type]
  end
end
