# This migration comes from payment (originally 20170308052032)
class AddPayeeToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :owner_id, :integer
    add_column :payment_transactions, :owner_type, :string
    add_column :payment_transactions, :payee, :string  # 收款人信息
    add_column :payment_transactions, :close, :boolean, default: false # 是否关闭显示

    add_index :payment_transactions, :close
    add_index :payment_transactions, [:owner_id, :owner_type]
  end
end
