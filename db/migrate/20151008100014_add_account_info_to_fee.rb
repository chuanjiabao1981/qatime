class AddAccountInfoToFee < ActiveRecord::Migration
  def change
    add_column :fees,:student_account_id,:integer
    add_column :fees,:teacher_account_id,:integer
  end
end
