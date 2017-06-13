# This migration comes from recommend (originally 20170613025007)
class AddTopToItems < ActiveRecord::Migration
  def change
    add_column :recommend_items, :top, :boolean
    add_column :recommend_items, :replay_times, :integer, default: 0
  end
end
