class AddCommentsCountToSolutionAndCorrection < ActiveRecord::Migration
  def change
    add_column :solutions   ,:comments_count,:integer,:default => 0
    add_column :corrections ,:comments_count,:integer,:default => 0
  end
end
