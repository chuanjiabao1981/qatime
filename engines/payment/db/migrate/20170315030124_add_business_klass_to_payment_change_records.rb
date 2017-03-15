class AddBusinessKlassToPaymentChangeRecords < ActiveRecord::Migration
  def change
    add_column :payment_change_records, :business_klass, :string, index: true
  end
end
