require_dependency "live_studio/application_controller"

module LiveStudio
  class Workstation::CourseRequestsController < ApplicationController
    layout :current_user_layout

    before_action :set_owner
    before_action :set_course_request, only: [:accept, :reject]

    def index
      @course_requests = @workstation.course_requests.includes(:course, :user)
      @course_requests = 'handled' == params[:status] ? @course_requests.handled : @course_requests.submitted
      @course_requests = @course_requests.where(live_studio_courses: course_search_params) if course_search_params.present?
      @course_requests = @course_requests.order(id: :desc).paginate(page: params[:page])
    end

    def accept
      @course_request.accept!
      redirect_to live_studio.user_course_requests_path(@current_resource)
    end

    def reject
      @course_request.reject!
      redirect_to live_studio.user_course_requests_path(@current_resource)
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
      @course_search_params = params.permit(:subject, :grade).select {|_k, v| v.present? }
    end

    def set_course_request
      @course_request = @workstation.course_requests.find(params[:id])
    end
  end
end
