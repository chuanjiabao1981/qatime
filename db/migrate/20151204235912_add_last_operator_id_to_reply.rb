class AddLastOperatorIdToReply < ActiveRecord::Migration
  def change
    add_column :replies,:last_operator_id,:integer
  end
end
