# This migration comes from live_studio (originally 20170922061541)
class AddUsersCountToVideoCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_video_courses, :users_count, :integer, default: 0
    LiveStudio::VideoCourse.all.each do |c|
      c.increment!(:users_count, c.buy_tickets_count + c.adjust_buy_count) if c.users_count.zero?
    end
  end
end
