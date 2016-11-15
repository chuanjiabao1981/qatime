module Permissions
  class WaiterPermission < StaffPermission
    def initialize(user)
      super(user)

      allow :sessions, [:destroy]
      allow :home, [:index, :new_index]
      allow "waiters/home", [:main]

      ## begin live studio permission
      allow 'live_studio/waiter/courses', [:index, :show] do |resource|
        resource == user
      end
      ## end live studio permission
    end
  end
end
