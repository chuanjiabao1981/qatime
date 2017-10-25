class AddMaxUsersToLiveStudioGroups < ActiveRecord::Migration
  def change
    add_column :live_studio_groups, :max_users, :integer, default: 10
  end
end
