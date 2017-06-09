class AddNameToRecommendItems < ActiveRecord::Migration
  def change
    add_column :recommend_items, :name, :string
  end
end
