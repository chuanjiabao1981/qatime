class AddRechargeCodeIndex < ActiveRecord::Migration
  def change
    add_index :recharge_codes,:code
  end
end
