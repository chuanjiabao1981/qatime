# This migration comes from live_studio (originally 20170619074128)
class AddUserToLiveStudioTicketItems < ActiveRecord::Migration
  def change
    add_reference :live_studio_ticket_items, :user
    LiveStudio::TicketItem.includes(:ticket).each do |item|
      next if item.user_id
      item.user_id = item.ticket.student_id
      item.save
    end
  end
end
