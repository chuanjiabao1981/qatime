module Permissions
  class ManagerPermission < BasePermission
    def initialize(user)
      allow "managers/register_codes",[:index,:create,:new]

      allow "managers/home",[:main]

      allow :sessions,[:destroy]

    end
  end
end