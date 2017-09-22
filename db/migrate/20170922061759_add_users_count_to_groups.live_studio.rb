# This migration comes from live_studio (originally 20170922061609)
class AddUsersCountToGroups < ActiveRecord::Migration
  def change
    add_column :live_studio_groups, :users_count, :integer, default: 0
    LiveStudio::Group.all.each do |c|
      c.increment!(:users_count, c.buy_tickets_count + c.adjust_tickets_count) if c.users_count.zero?
    end
  end
end
