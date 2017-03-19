# This migration comes from recommend (originally 20170316101214)
class AddTagOneToRecommendItems < ActiveRecord::Migration
  def change
    add_column :recommend_items, :tag_one, :integer
    add_column :recommend_items, :tag_two, :integer
    add_index :recommend_items, :tag_one
    add_index :recommend_items, :tag_two
  end
end
