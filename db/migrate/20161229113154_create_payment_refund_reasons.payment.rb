# This migration comes from payment (originally 20161229112928)
class CreatePaymentRefundReasons < ActiveRecord::Migration
  def change
    create_table :payment_refund_reasons do |t|
      t.integer :payment_refund_apply_id
      t.text :reason
      t.timestamps null: false
    end
  end
end
