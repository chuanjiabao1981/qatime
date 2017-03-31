# This migration comes from live_studio (originally 20170331052512)
class AddAnnouncementableToLiveStudioAnnouncements < ActiveRecord::Migration
  def change
    add_reference :live_studio_announcements, :announcementable, polymorphic: true
  end
end
