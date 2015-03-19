module Permissions
  class ManagerPermission < BasePermission
    def initialize(user)
      allow "managers/register_codes",[:index,:create,:new]

      allow "managers/home",[:main]
      allow :home,[:index]

      allow :curriculums,[:index,:show]
      allow :courses,[:show]

      allow :sessions,[:destroy]

    end
  end
end