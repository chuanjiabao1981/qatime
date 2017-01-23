# This migration comes from payment (originally 20170119073312)
class ChangeDecimalColumnForPaymentChangeRecords < ActiveRecord::Migration
  def change
    change_column :payment_change_records, :different, :decimal, precision: 16, scale: 2
    change_column :payment_change_records, :before, :decimal, precision: 16, scale: 2
    change_column :payment_change_records, :after, :decimal, precision: 16, scale: 2
    change_column :payment_change_records, :amount, :decimal, precision: 16, scale: 2
  end
end
