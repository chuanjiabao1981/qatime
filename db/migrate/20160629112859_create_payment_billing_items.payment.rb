# This migration comes from payment (originally 20160629062345)
class CreatePaymentBillingItems < ActiveRecord::Migration
  def change
    create_table :payment_billing_items do |t|
      t.references :billing, index: true
      t.references :account, polymorphic: true, index: true
      t.decimal :total_money, precision: 8, scale: 2
      t.datetime :deleted_at
      t.string :summary

      t.timestamps null: false
    end
  end
end
