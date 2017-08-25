# This migration comes from resource (originally 20170825075327)
class CreateResourceVideoInfos < ActiveRecord::Migration
  def change
    create_table :resource_video_infos do |t|
      t.integer :duration
      t.string :capture
      t.string :url
      t.string :sd_mp4_url
      t.string :hd_mp4_url
      t.string :shd_mp4_url

      t.timestamps null: false
    end
  end
end
