# This migration comes from live_studio (originally 20161122044108)
class AddDurationToLessons < ActiveRecord::Migration
  def change
    add_column :live_studio_lessons, :duration, :integer
  end
end
