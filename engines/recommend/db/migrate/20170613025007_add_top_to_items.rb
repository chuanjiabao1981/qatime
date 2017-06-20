class AddTopToItems < ActiveRecord::Migration
  def change
    add_column :recommend_items, :top, :boolean
    add_column :recommend_items, :replay_times, :integer, default: 0
  end
end
