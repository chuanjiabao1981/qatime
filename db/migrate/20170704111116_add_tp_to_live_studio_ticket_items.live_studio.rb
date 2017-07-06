# This migration comes from live_studio (originally 20170704105931)
class AddTpToLiveStudioTicketItems < ActiveRecord::Migration
  def change
    add_column :live_studio_ticket_items, :tp, :integer, limit: 2, default: 0
  end
end
