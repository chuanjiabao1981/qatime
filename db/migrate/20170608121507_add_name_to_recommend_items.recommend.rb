# This migration comes from recommend (originally 20170608121404)
class AddNameToRecommendItems < ActiveRecord::Migration
  def change
    add_column :recommend_items, :name, :string
  end
end
