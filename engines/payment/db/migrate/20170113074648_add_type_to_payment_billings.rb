class AddTypeToPaymentBillings < ActiveRecord::Migration
  def change
    add_column :payment_billings, :type, :string
    add_column :payment_billings, :percent, :integer, default: 0
    add_column :payment_billings, :quantity, :integer, default: 0
    add_column :payment_billings, :price, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
