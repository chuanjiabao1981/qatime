# This migration comes from live_studio (originally 20170216103400)
class AddSellChannelAndChannelOwnerToLiveStudioTickets < ActiveRecord::Migration
  def change
    add_reference :live_studio_tickets, :sell_channel, polymorphic: true
    add_reference :live_studio_tickets, :channel_owner, polymorphic: true
  end
end
