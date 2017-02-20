# This migration comes from live_studio (originally 20170111130051)
class CreateLiveStudioTicketItems < ActiveRecord::Migration
  def change
    create_table :live_studio_ticket_items do |t|
      t.references :ticket, index: true
      t.references :lesson, index: true
      t.integer :status, default: 0
      t.datetime :used_at

      t.timestamps null: false
    end
  end
end
