class CreatePaymentBillings < ActiveRecord::Migration
  def change
    create_table :payment_billings do |t|
      t.references :target, polymorphic: true, index: true
      t.decimal :total_money, precision: 8, scale: 2
      t.datetime :deleted_at
      t.string :summary

      t.timestamps null: false
    end
  end
end
