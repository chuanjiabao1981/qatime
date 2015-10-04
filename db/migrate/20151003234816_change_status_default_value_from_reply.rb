class ChangeStatusDefaultValueFromReply < ActiveRecord::Migration
  def change
    rename_column :fees, :feedable_id, :feeable_id
  end
end
