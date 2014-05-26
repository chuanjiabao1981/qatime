class RemoveUserMoney < ActiveRecord::Migration
  def change
    remove_column :users,:money,:integer
    remove_column :users,:lock_version,:integer
  end
end
