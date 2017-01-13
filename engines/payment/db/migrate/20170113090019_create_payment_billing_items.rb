class CreatePaymentBillingItems < ActiveRecord::Migration
  def change
    create_table :payment_billing_items do |t|
      t.references :billing, index: true
      t.references :cash_account, index: true
      t.references :owner, polymorphic: true, index: true
      t.decimal :amount, precision: 8
      t.integer :quantity
      t.integer :duration
      t.integer :percent
      t.decimal :price, precision: 8
      t.integer :parent_id
      t.string :type

      t.timestamps null: false
    end
  end
end
