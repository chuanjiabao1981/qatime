class AddForSellToLiveStudioGroups < ActiveRecord::Migration
  def change
    add_column :live_studio_groups, :for_sell, :boolean, default: false

    LiveStudio::Group.where(status: LiveStudio::Group.statuses.values_at(:published, :teaching)).find_each do |group|
      next if group.for_sell
      group.for_sell = true
      group.save
    end
  end
end
