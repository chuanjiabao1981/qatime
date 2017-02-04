require_dependency "live_studio/application_controller"

module LiveStudio
  class Workstation::CoursesController < ApplicationController
    layout :current_user_layout

    before_action :set_workstation

    def index
      @courses = @workstation.live_studio_courses.includes(:teacher).where(course_search_params).paginate(page: params[:page])
    end

    private
    def set_workstation
      @workstation ||= ::Workstation.find(params[:workstation_id])
    end

    def current_resource
      set_workstation
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
