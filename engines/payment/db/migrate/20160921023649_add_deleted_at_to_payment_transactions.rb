class AddDeletedAtToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :deleted_at, :datetime
  end
end
