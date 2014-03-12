class AddNodeIdToTutorial < ActiveRecord::Migration
  def change
    add_column :tutorials,:node_id,:integer
    add_column :nodes,:tutorials_count,:integer,:default => 0
  end
end
