class AddStudentToRechargeCode < ActiveRecord::Migration
  def change
    add_column      :recharge_codes,:student_id,:integer
    remove_column   :recharge_codes,:is_used,:boolean
    add_column      :recharge_codes,:lock_version, :integer, default: 0
  end
end
