# This migration comes from payment (originally 20161024040129)
class AddFrozenBalanceToCashAccount < ActiveRecord::Migration
  def change
    add_column :payment_cash_accounts, :frozen_balance, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
