class CreateLiveStudioChannelVideos < ActiveRecord::Migration
  def change
    create_table :live_studio_channel_videos do |t|
      t.belongs_to :channel, class_name: 'LiveStudio::Channel'
      t.integer :vid
      t.string :name
      t.string :key
      t.timestamps null: false
    end
  end
end
