# This migration comes from payment (originally 20170315030124)
class AddBusinessKlassToPaymentChangeRecords < ActiveRecord::Migration
  def change
    add_column :payment_change_records, :business_klass, :string, index: true
  end
end
