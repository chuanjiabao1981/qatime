module Permissions
  class WaiterPermission < StaffPermission
    def initialize(user)
      super(user)

      allow :sessions, [:destroy]
      allow :home, [:index]
      allow "managers/home", [:main]

      ## begin live studio permission
      allow 'live_studio/manager/courses', [:index, :show]
      ## end live studio permission
    end
  end
end
