# This migration comes from payment (originally 20160630052721)
class CreatePaymentChangeRecords < ActiveRecord::Migration
  def change
    create_table :payment_change_records do |t|
      t.references :cash_account, index: true
      t.decimal :different, precision: 8, scale: 2, default: 0.0
      t.decimal :before, precision: 8, scale: 2, default: 0.0
      t.decimal :after, precision: 8, scale: 2, default: 0.0
      t.references :billing, index: true
      t.string :summary
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
