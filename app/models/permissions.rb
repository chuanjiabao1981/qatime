module Permissions
  def self.permission_for(user)
    return GuestPermission.new if user.nil? || user.guest?
    "permissions/#{user.role}_permission".camelize.safe_constantize.new(user)
  end
end
