class RemoveLockFromAccount < ActiveRecord::Migration
  def change
    remove_column :accounts,:lock_version,:integer
    remove_column :accounts,:student_id,:integer
    add_column :accounts,:user_id,:integer
  end
end
