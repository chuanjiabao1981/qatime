class AddPartnerIdAndTimestampToOrders < ActiveRecord::Migration
  def change
    rename_column :payment_orders, :prepayid, :prepa_yid
    rename_column :payment_orders, :noncestr, :nonce_str
  end
end
