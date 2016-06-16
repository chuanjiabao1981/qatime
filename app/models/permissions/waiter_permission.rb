module Permissions
  class WaiterPermission < StaffPermission
    def initialize(user)
      super(user)

      ## begin live studio permission
      allow 'live_studio/manager/courses', [:index, :show]
      ## end live studio permission
    end
  end
end
