module Permissions
  class CashAdminPermission < BasePermission
    def initialize
      super(user)
    end
  end
end