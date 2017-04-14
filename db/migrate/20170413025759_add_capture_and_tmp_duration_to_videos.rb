class AddCaptureAndTmpDurationToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :capture, :string
    add_column :videos, :tmp_duration, :integer, default: 0
  end
end
