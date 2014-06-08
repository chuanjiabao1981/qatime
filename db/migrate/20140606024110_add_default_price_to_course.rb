class AddDefaultPriceToCourse < ActiveRecord::Migration
  def change
    change_column :courses,:price,:float,:default => 30.0
  end
end
