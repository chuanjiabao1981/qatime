class AddLastOperatorToTopic < ActiveRecord::Migration
  def change
    add_column :topics,:last_operator_id,:integer
  end
end
