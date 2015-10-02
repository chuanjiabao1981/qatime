class RemoveStatusFromFee < ActiveRecord::Migration
  def change
    remove_column :fees,:status,:boolean
  end
end