class AddFromUserToPaymentChangeRecords < ActiveRecord::Migration
  def change
    add_reference :payment_change_records, :from_user, index: true
  end
end
