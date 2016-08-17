# This migration comes from payment (originally 20160815060822)
class AddPartnerIdAndTimestampToOrders < ActiveRecord::Migration
  def change
    rename_column :payment_orders, :prepayid, :prepay_id
    rename_column :payment_orders, :noncestr, :nonce_str
  end
end
