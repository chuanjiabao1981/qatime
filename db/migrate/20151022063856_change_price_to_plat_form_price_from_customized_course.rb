class ChangePriceToPlatFormPriceFromCustomizedCourse < ActiveRecord::Migration
  def change
    rename_column :customized_courses, :price, :platform_price
  end
end
