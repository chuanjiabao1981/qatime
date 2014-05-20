module Permissions
  class StudentPermission < BasePermission
    def initialize(user)
      allow :home,[:index]
      allow :groups,[:index,:show]
      allow :courses,[:show]
      allow :sessions,[:destroy]
      allow 'students/home',[:main]
      allow 'students/registrations',[:edit,:update,:show]
    end
  end
end