class AddCommentsCountToExercise < ActiveRecord::Migration
  def change
    add_column :exercises,:comments_count,:integer,:default => 0

  end
end
