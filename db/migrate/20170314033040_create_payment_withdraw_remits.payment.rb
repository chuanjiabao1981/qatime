# This migration comes from payment (originally 20170314030037)
class CreatePaymentWithdrawRemits < ActiveRecord::Migration
  def change
    create_table :payment_withdraw_remits do |t|
      t.integer :pay_type # 转款方式
      t.string :pay_username # 转款人
      t.datetime :remit_at # 转款日期
      t.string :pic # 转款证明
      t.references :target, polymorphic: true, index: true

      t.timestamps null: false
    end

    add_index :payment_withdraw_remits, :pay_type
  end
end
