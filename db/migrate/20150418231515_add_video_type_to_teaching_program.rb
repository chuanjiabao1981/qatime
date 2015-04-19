class AddVideoTypeToTeachingProgram < ActiveRecord::Migration
  def change
    add_column :teaching_videos,:video_type,:string,default: 'mp4'
    TeachingVideo.all.each do |t|
      t.video_type = 'mp4'
      t.save
    end
  end
end
