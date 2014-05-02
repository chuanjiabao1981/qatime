class Users::SessionsController < Devise::SessionsController
  def create
    rtn = super
    sign_in(resource.role.underscore, resource) unless resource.role.nil?
    rtn
  end
end
