# This migration comes from live_studio (originally 20161201065837)
class AlterLessonColumnForLessons < ActiveRecord::Migration
  def change
    remove_column :live_studio_channels, :beat_step
    add_column :live_studio_lessons, :beat_step, :integer, default: 60
  end
end
