class ChangeFeeConlumnName < ActiveRecord::Migration
  def change
    rename_column :fees,:student_account_id,:consumption_account_id
    rename_column :fees,:teacher_account_id,:earning_account_id
  end
end
