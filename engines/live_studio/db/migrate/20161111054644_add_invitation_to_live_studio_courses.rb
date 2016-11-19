class AddInvitationToLiveStudioCourses < ActiveRecord::Migration
  def change
    add_reference :live_studio_courses, :invitation, index: true
  end
end
