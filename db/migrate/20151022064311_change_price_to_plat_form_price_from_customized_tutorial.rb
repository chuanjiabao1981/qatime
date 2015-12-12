class ChangePriceToPlatFormPriceFromCustomizedTutorial < ActiveRecord::Migration
  def change
    rename_column :customized_tutorials, :price, :platform_price
  end
end
