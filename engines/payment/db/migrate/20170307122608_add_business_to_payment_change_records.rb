class AddBusinessToPaymentChangeRecords < ActiveRecord::Migration
  def change
    add_reference :payment_change_records, :business, polymorphic: true
  end
end
