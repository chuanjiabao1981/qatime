class AddCommentsCounterToTutorial < ActiveRecord::Migration
  def change
    add_column :tutorials,:comments_count,:integer,:default => 0
  end
end
