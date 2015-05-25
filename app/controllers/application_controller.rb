class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper

  before_filter :authorize

  delegate :allow?, to: :current_permission
  helper_method :allow?

  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?
  layout :current_user_layout

  protected

  def current_permission
    @current_permission ||= Permissions.permission_for(current_user)
  end

  def current_resource
    nil
  end

  def authorize
    if current_user
      logger.info("#{current_user.name} visit #{params[:controller]}:#{params[:action]}")
    end
    if current_permission.allow?(params[:controller], params[:action], current_resource)
      current_permission.permit_params! params

    else
      flash[:warning] = "您没有权限进行这个操作!"
      logger.info("====================")
      logger.info(request.referer)
      if current_user
        logger.info(current_user.name)
      end
      logger.info("====================")
      if request.referer
        #redirect_to(request.referer)
        redirect_to user_home_path
      else
        redirect_to user_home_path
      end
    end
  end

  def current_user_layout
    if current_user.nil?
      "application"
    elsif current_user.manager?
      "manager_home"
    elsif current_user.admin?
      "admin_home"
    elsif current_user.teacher?
      "teacher_home"
    elsif current_user.student?
      "student_home"
    end
  end

end
