module Permissions
  class StudentPermission < BasePermission
    def initialize(user)
      allow :home,[:index]
      allow :groups,[:index,:show]
      allow :courses,[:show]
      allow :sessions,[:destroy]
      allow 'students/home',[:main]
      allow 'students/infos',[:show]
      allow 'students/registrations',[:edit,:update]
    end
  end
end