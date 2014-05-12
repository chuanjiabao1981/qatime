module Permissions
  def self.permission_for(user)
    if user.nil?
      GuestPermission.new
    elsif user.admin?
      AdminPermission.new(user)
    elsif user.teacher?
      TeacherPermission.new(user)
    else
      GuestPermission.new
    end
  end
end