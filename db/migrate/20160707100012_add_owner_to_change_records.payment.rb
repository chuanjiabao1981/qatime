# This migration comes from payment (originally 20160707095720)
class AddOwnerToChangeRecords < ActiveRecord::Migration
  def change
    add_reference :payment_change_records, :owner, polymorphic: true, index: true

    Payment::ChangeRecord.find_each do |record|
      record.owner = record.cash_account.owner
      record.save
    end
  end
end
