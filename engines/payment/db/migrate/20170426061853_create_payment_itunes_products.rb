class CreatePaymentItunesProducts < ActiveRecord::Migration
  def change
    create_table :payment_itunes_products do |t|
      t.string :name
      t.string :product_id
      t.decimal :price, precision: 8, scale: 2, default: 0
      t.decimal :amount, precision: 8, scale: 2, default: 0
      t.boolean :online, default: false

      t.timestamps null: false
    end
  end
end
