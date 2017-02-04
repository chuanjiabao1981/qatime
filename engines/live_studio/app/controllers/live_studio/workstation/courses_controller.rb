require_dependency "live_studio/application_controller"

module LiveStudio
  class Workstation::CoursesController < ApplicationController
    layout :current_user_layout

    before_action :set_owner

    def index
      @courses = @workstation.live_studio_courses.includes(:teacher).where(course_search_params).paginate(page: params[:page])
    end

    private
    def set_owner
      @owner ||= User.find(params[:user_id])
      @workstation ||= @owner.manager? ? @owner.workstations.first : @owner.workstation
      @owner
    end

    def current_resource
      @current_resource ||= set_owner
    end

    def course_search_params
      @course_search_params = params.permit(:status, :subject, :grade).select {|_k, v| v.present? }
      @course_search_params[:status] =
        if params[:status].present?
          LiveStudio::Course.statuses.values_at(params[:status])
        else
          LiveStudio::Course.statuses.values_at(:published, :teaching, :completed)
        end
      @course_search_params
    end
  end
end
