class AddSellPercentageAndPlatformPercentageToLiveStudioTickets < ActiveRecord::Migration
  def change
    remove_column :live_studio_tickets, :cross_region_percentage
    remove_column :live_studio_tickets, :sell_channel_id
    remove_reference :live_studio_tickets, :channel_owner

    add_column :live_studio_tickets, :sell_percentage, :integer, default: 0
    add_column :live_studio_tickets, :platform_percentage, :integer, default: 0
  end
end
