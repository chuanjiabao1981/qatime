module Permissions
  class SellerPermission < StaffPermission
    def initialize(user)
      super(user)

      allow :sessions,[:destroy]
      allow :home,[:index,:new_index,:switch_city]
      allow "sellers/home", [:main]

      allow :sellers, [:customized_courses]
      allow :customized_courses, [:show,:edit,:update,:teachers,:topics,:homeworks,:solutions, :get_sale_price] do |customized_course|
        user && customized_course && user.customized_courses.include?(customized_course)
      end

      allow :customized_courses ,[:new,:create] do |student|
        user and student
      end


      ## begin live studio permission
      allow 'live_studio/seller/courses', [:index, :show, :new, :create, :edit, :update] do |resource, course, action|
        # seller操作辅导班权限细分
        resource.id == user.id && (course.try(:init?) || %w(index show new create).include?(action))
      end
      ## end live studio permission
    end
  end
end
