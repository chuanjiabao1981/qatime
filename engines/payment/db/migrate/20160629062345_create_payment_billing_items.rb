class CreatePaymentBillingItems < ActiveRecord::Migration
  def change
    create_table :payment_billing_items do |t|
      t.references :billing, index: true, foreign_key: true
      t.references :account, polymorphic: true, index: true
      t.decimal :total_money, precision: 8, scale: 2
      t.datetime :deleted_at
      t.string :summary

      t.timestamps null: false
    end
  end
end
