class AddLockVersionToStudent < ActiveRecord::Migration
  def change
    add_column :users,:lock_version,:integer,:default => 0
  end
end
