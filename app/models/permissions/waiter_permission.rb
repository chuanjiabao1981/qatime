module Permissions
  class WaiterPermission < StaffPermission
    def initialize(user)
      super(user)

      allow :sessions, [:destroy]
      allow :home,[:index,:new_index,:switch_city]
      allow "waiters/home", [:main]

      allow :waiters, [:customized_courses]
      allow :customized_courses, [:show,:edit,:update,:teachers,:topics,:homeworks,:solutions, :get_sale_price] do |customized_course|
        user && customized_course && user.customized_courses.include?(customized_course)
      end

      allow :customized_courses ,[:new,:create] do |student|
        user and student
      end

      ## begin live studio permission
      allow 'live_studio/waiter/courses', [:index, :show] do |resource|
        resource == user
      end
      ## end live studio permission
    end
  end
end
