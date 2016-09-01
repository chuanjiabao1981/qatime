# This migration comes from live_studio (originally 20160830011923)
class AddPublishedAtToCourses < ActiveRecord::Migration
  def change
    add_column :live_studio_courses, :published_at, :datetime

    LiveStudio::Course.where.not(status: LiveStudio::Course.statuses['init']).find_each(:batch_size => 1000) do |course|
      course.update(published_at: course.updated_at)
    end
  end
end
