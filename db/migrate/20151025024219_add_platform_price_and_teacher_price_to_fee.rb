class AddPlatformPriceAndTeacherPriceToFee < ActiveRecord::Migration
  def change
    add_column :fees, :platform_price, :integer
    add_column :fees, :teacher_price, :integer
    remove_column :fees, :price_per_minute, :float
  end
end
