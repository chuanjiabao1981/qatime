class AddLastOperator < ActiveRecord::Migration
  def change
    add_column :solutions,:last_operator_id,:integer
  end
end
