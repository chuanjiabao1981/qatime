class AddTastableToLiveStudioVideoLessons < ActiveRecord::Migration
  def change
    add_column :live_studio_video_lessons, :tastable, :boolean
  end
end
