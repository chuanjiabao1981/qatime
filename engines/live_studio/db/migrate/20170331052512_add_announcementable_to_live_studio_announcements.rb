class AddAnnouncementableToLiveStudioAnnouncements < ActiveRecord::Migration
  def change
    add_reference :live_studio_announcements, :announcementable, polymorphic: true
  end
end
