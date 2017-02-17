class AddSellChannelAndChannelOwnerToLiveStudioTickets < ActiveRecord::Migration
  def change
    add_reference :live_studio_tickets, :sell_channel, polymorphic: true
    add_reference :live_studio_tickets, :channel_owner, polymorphic: true
  end
end
