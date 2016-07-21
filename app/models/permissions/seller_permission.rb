module Permissions
  class SellerPermission < StaffPermission
    def initialize(user)
      super(user)

      allow :sessions,[:destroy]
      allow :home, [:index]
      allow "sellers/home", [:main]

      ## begin live studio permission
      allow 'live_studio/seller/courses', [:index, :show, :new, :create, :edit, :update] do |resource, course, action|
        # seller操作辅导班权限细分
        resource.id == user.id && (course.try(:init?) || %w(index show new create).include?(action))
      end
      ## end live studio permission
    end
  end
end
