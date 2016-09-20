class AddTypeAndReferenceToChangeRecords < ActiveRecord::Migration
  def change
    add_column :payment_change_records, :type, :string, limit: 128, default: 'Payment::ChangeRecord'
    add_reference :payment_change_records, :target, polymorphic: true, index: true
  end
end
