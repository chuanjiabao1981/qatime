class AddTargetToLiveStudioTicketItems < ActiveRecord::Migration
  def change
    add_reference :live_studio_ticket_items, :target, polymorphic: true
  end
end
