# This migration comes from live_studio (originally 20170413094940)
class AddVideoToLiveStudioVideoLessons < ActiveRecord::Migration
  def change
    add_reference :live_studio_video_lessons, :video
  end
end
