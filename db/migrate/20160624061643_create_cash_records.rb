class CreateCashRecords < ActiveRecord::Migration
  def change
    create_table :cash_records do |t|
      t.references :cash_account, index: true
      t.decimal :before, precision: 10, scale: 2
      t.decimal :after, precision: 10, scale: 2
      t.decimal :different, precision: 10, scale: 2
      t.references :ref, polymorphic: true, index: true
      t.string :remark

      t.timestamps null: false
    end
  end
end
