class AddTokenToLiveStudioVideoLessons < ActiveRecord::Migration
  def change
    add_column :live_studio_video_lessons, :token, :string
  end
end
