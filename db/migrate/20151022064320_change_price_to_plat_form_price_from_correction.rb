class ChangePriceToPlatFormPriceFromCorrection < ActiveRecord::Migration
  def change
    rename_column :corrections, :price, :platform_price
  end
end
