class AddActionTypeToNotifications < ActiveRecord::Migration
  def change
    add_reference :notifications, :from, polymorphic: true
  end
end
