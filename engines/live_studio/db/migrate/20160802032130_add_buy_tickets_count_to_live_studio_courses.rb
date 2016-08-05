class AddBuyTicketsCountToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :buy_tickets_count, :integer, default: 0

    LiveStudio::Course.pluck(:id).each do |i|
      LiveStudio::Course.reset_counters(i, :buy_tickets) # 全部重算一次
    end
  end
end
