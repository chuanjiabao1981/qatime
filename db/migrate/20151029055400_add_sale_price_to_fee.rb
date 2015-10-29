class AddSalePriceToFee < ActiveRecord::Migration
  def change
    add_column :fees, :sale_price, :float
  end
end
