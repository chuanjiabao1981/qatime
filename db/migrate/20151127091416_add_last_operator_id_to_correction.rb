class AddLastOperatorIdToCorrection < ActiveRecord::Migration
  def change
    add_column :corrections,:last_operator_id,:integer
  end
end
