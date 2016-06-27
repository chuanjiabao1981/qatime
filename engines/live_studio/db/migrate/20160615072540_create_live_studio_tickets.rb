class CreateLiveStudioTickets < ActiveRecord::Migration
  def change
    create_table :live_studio_tickets do |t|
      t.references :course, index: true
      t.references :student, index: true
      t.references :lesson, index: true
      t.integer :status, limit: 2, default: 0
      t.string :type

      t.timestamps null: false
    end
  end
end
