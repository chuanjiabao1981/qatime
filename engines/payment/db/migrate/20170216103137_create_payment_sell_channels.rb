class CreatePaymentSellChannels < ActiveRecord::Migration
  def change
    create_table :payment_sell_channels do |t|
      t.references :owner, polymorphic: true, index: true
      t.references :target, polymorphic: true, index: true
      t.integer :percentage
      t.string :type

      t.timestamps null: false
    end
  end
end
