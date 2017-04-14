class AddVideoToLiveStudioVideoLessons < ActiveRecord::Migration
  def change
    add_reference :live_studio_video_lessons, :video
  end
end
