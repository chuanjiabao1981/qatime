module Permissions
  class TeacherPermission < BasePermission
    def initialize(user)
      allow :groups,[:index,:show]
      allow :home,[:index]
    end
  end
end