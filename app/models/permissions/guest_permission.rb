module Permissions
  class GuestPermission < BasePermission
    def initialize
      allow :home,[:index]
      allow :sessions,[:new,:create]
      allow "students/registrations",[:new,:create]
      allow "teachers/registrations",[:new,:create]
      allow :teaching_videos,[:show]

    end
  end
end