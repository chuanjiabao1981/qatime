# This migration comes from live_studio (originally 20171025023218)
class AddMaxUsersToLiveStudioGroups < ActiveRecord::Migration
  def change
    add_column :live_studio_groups, :max_users, :integer, default: 10
  end
end
