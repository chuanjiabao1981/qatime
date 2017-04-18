# This migration comes from live_studio (originally 20170418081255)
class AddTastableToLiveStudioVideoLessons < ActiveRecord::Migration
  def change
    add_column :live_studio_video_lessons, :tastable, :boolean
  end
end
