class AddRechargeCodeId < ActiveRecord::Migration
  def change
    add_column :recharge_records,:recharge_code_id,:integer
  end
end
