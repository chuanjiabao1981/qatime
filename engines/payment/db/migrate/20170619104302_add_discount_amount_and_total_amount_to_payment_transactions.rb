class AddDiscountAmountAndTotalAmountToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :discount_amount, :decimal, precision: 8, scale: 2, default: 0
    add_column :payment_transactions, :total_amount, :decimal, precision: 8, scale: 2, default: 0
  end
end
