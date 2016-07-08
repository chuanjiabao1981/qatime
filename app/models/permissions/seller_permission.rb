module Permissions
  class SellerPermission < StaffPermission
    def initialize(user)
      super(user)

      allow :sessions,[:destroy]
      allow :home, [:index]
      allow "sellers/home", [:main]

      ## begin live studio permission
      allow 'live_studio/seller/courses', [:index, :show, :new, :create, :edit, :update, :destroy, :publish] do |resource|
        resource.id == user.id
      end
      ## end live studio permission
    end
  end
end
