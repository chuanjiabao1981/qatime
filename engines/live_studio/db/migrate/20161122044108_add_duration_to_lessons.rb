class AddDurationToLessons < ActiveRecord::Migration
  def change
    add_column :live_studio_lessons, :duration, :integer
  end
end
