class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper

  before_action :authorize
  before_action :set_city

  delegate :allow?, to: :current_permission
  helper_method :allow?

  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?
  layout :current_user_layout

  protected

  def flash_msg(status = :notice, msg = "")
    flash[status] = msg
  end

  def i18n_notice(type, model)
    t("activerecord.successful.messages.#{type}", model: model.class.model_name.human)
  end
  def i18n_failed(type, model)
    t("activerecord.failed.messages.#{type}", model: model.class.model_name.human)
  end

  def current_permission
    @current_permission ||= Permissions.permission_for(current_user)
  end

  def current_resource
    nil
  end

  def authorize
    if current_user
      logger.info("#{current_user.name} visit #{params[:controller]}:#{params[:action]}")
      if current_user.student_or_teacher? && current_user.name.blank?
        if action_name != 'edit' && !(controller_name == 'sessions' && action_name == 'destroy') && !(action_name == 'update' && params[:by] == 'register')
          if current_user.student?
            return redirect_to main_app.edit_student_path(current_user, cate: :register, by: :register), alert: t("flash.alert.please_improve_your_info")
          else
            return redirect_to main_app.edit_teacher_path(current_user, cate: :register, by: :register), alert: t("flash.alert.please_improve_your_info")
          end
        end
      end

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
      return unauthorized
    end
  end

  def unauthorized
    redirect_to user_home_path
  end

  def wap_unauthorized
    redirect_to wap_user_home_path
  end

  def current_user_layout
    if current_user.nil?
      "application"
    elsif current_user.manager?
      "manager_home"
    elsif current_user.admin?
      "admin_home"
    elsif current_user.teacher?
      "teacher_home_new"
    elsif current_user.student?
      'student_home_new'
    elsif current_user.seller?
      'seller_home'
    elsif current_user.waiter?
      'waiter_home'
    end
  end

end
