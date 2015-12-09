class AddCommentsCountToTopics < ActiveRecord::Migration
  def change
    add_column :topics,:comments_count,:integer,:default => 0
    add_column :replies,:comments_count,:integer,:default => 0
  end
end
