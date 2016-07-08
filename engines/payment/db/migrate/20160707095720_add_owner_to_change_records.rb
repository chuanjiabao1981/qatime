class AddOwnerToChangeRecords < ActiveRecord::Migration
  def change
    add_reference :payment_change_records, :owner, polymorphic: true, index: true
  end
end
