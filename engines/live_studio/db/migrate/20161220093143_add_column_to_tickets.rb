class AddColumnToTickets < ActiveRecord::Migration
  def change
    add_column :live_studio_tickets, :got_lesson_ids, :text
  end
end
