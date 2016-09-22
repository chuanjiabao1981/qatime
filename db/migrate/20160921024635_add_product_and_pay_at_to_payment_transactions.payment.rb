# This migration comes from payment (originally 20160921024513)
class AddProductAndPayAtToPaymentTransactions < ActiveRecord::Migration
  def change
    add_reference :payment_transactions, :product, polymorphic: true
    add_column :payment_transactions, :pay_at, :datetime
  end
end
