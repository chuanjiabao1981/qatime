module Permissions
  class GuestPermission < BasePermission
    def initialize
      allow :home,[:index]
      allow :sessions,[:new,:create]
    end
  end
end