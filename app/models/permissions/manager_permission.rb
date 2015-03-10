module Permissions
  class ManagerPermission < BasePermission
    def initialize(user)
      allow "managers/register_codes",[:index,:create]

      allow "managers/home",[:main]

    end
  end
end