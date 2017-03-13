class AddSellPercentageAndPlatformPercentageToLiveStudioTickets < ActiveRecord::Migration
  def change
    remove_column :live_studio_tickets, :cross_region_percentage, :integer, default: 0
    remove_column :live_studio_tickets, :sell_channel_id, :integer, default: 0
    remove_reference :live_studio_tickets, :channel_owner, polymorphic: true

    add_column :live_studio_tickets, :sell_percentage, :integer, default: 0
    add_column :live_studio_tickets, :platform_percentage, :integer, default: 0
  end
end
