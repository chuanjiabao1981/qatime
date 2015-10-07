class AddDurationToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :duration,:integer
  end
end
