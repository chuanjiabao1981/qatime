class AddTypeAndTargetToChangeRecords < ActiveRecord::Migration
  def change
    add_column :payment_change_records, :type, :string, limit: 128, default: 'Payment::ChangeRecord'
    add_reference :payment_change_records, :target, polymorphic: true, index: true
    add_column :payment_change_records, :change_type, :integer, limit: 4
    add_column :payment_change_records, :amount, :decimal, precision: 8, scale: 2, default: 0
  end
end
