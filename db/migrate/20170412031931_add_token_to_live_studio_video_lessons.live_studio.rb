# This migration comes from live_studio (originally 20170412031845)
class AddTokenToLiveStudioVideoLessons < ActiveRecord::Migration
  def change
    add_column :live_studio_video_lessons, :token, :string
  end
end
