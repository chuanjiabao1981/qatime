module LiveStudio
  module SessionsHelper

    # 重载资源权限参数
    def current_resource(variable=nil)
      @resource = User.find_by(id: params_user_id) || current_user
      @variable = variable || Course.find_by(id: params[:id]) if params[:controller].include?('courses')
      [@resource, @variable]
    end

    private
    def params_user_id
      roles = %w(admin manager seller waiter teacher student)
      role = roles.select{|role| /#{role}/.match(params[:controller])}.first
      params["#{role}_id"]
    end
  end
end
