module Permissions
  class SellerPermission < StaffPermission
    def initialize(user)
      super(user)

      ## begin live studio permission
      allow 'live_studio/manager/courses', [:index, :show, :new, :create, :edit, :update]
      ## end live studio permission
    end
  end
end
