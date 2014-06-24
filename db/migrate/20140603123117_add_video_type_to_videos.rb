class AddVideoTypeToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :video_type, :string, :default => "mp4"
  end
end