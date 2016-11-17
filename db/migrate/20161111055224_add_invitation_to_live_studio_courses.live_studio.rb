# This migration comes from live_studio (originally 20161111054644)
class AddInvitationToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_reference :live_studio_courses, :invitation, index: true
  end
end
