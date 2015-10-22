class ChangePriceToPlatFormPriceFromReplies < ActiveRecord::Migration
  def change
    rename_column :replies, :price, :platform_price
  end
end
