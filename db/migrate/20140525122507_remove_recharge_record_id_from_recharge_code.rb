class RemoveRechargeRecordIdFromRechargeCode < ActiveRecord::Migration
  def change
    remove_column :recharge_codes,:recharge_record_id,:integer
  end
end
