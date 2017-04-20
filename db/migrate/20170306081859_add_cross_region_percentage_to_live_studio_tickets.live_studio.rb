# This migration comes from live_studio (originally 20170306081607)
class AddCrossRegionPercentageToLiveStudioTickets < ActiveRecord::Migration
  def change
    add_column :live_studio_tickets, :cross_region_percentage, :integer, default: 0
  end
end
