class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :order_no, limit: 64, index: true, comment: '订单编号'
      t.references :user, index: true, foreign_key: true
      t.references :product, polymorphic: true, index: true
      t.decimal :total_money, precision: 6, scale: 2, default: 0.0
      t.integer :state
      t.integer :pay_type, limit: 2

      t.timestamps null: false
    end
  end
end
