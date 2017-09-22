class AddUsersCountToCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :users_count, :integer, default: 0
    LiveStudio::Course.all.each do |c|
      c.increment!(:users_count, c.buy_tickets_count + c.adjust_buy_count) if c.users_count.zero?
    end
  end
end
