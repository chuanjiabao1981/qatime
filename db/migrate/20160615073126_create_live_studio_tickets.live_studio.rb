# This migration comes from live_studio (originally 20160615072540)
class CreateLiveStudioTickets < ActiveRecord::Migration
  def change
    create_table :live_studio_tickets do |t|
      t.references :course, index: true
      t.references :student, index: true
      t.references :lesson, index: true
      t.string :type

      t.timestamps null: false
    end
  end
end
