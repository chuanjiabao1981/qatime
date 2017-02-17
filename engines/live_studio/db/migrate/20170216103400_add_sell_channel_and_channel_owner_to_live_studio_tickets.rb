class AddSellChannelAndChannelOwnerToLiveStudioTickets < ActiveRecord::Migration
  def change
    add_reference :live_studio_tickets, :sell_channel
    add_reference :live_studio_tickets, :channel_owner, polymorphic: true
  end
end
