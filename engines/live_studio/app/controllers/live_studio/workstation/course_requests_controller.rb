require_dependency "live_studio/application_controller"

module LiveStudio
  class Workstation::CourseRequestsController < ApplicationController
    layout :current_user_layout

    before_action :set_owner

    def index
      @course_requests = @workstation.course_requests.includes(:course, :user)
      @course_requests = 'handled' == params[:status] ? @course_requests.handled : @course_requests.submitted
      @course_requests = @course_requests.where(live_studio_courses: course_search_params) if course_search_params.present?
      @course_requests = @course_requests.paginate(page: params[:page])
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
  end
end
