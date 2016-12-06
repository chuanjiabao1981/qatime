class AlterBeatStepForLessons < ActiveRecord::Migration
  def change
    remove_column :live_studio_lessons, :beat_step
    add_column :live_studio_live_sessions, :beat_step, :integer
  end
end
