module LiveStudio
  class CourseRequestsController < ApplicationController
    before_action :set_manager

    def index
      # 只有一个工作站
      @course_requests = @manager.course_requests.includes(:course)
      @course_requests = @course_requests.where(search_params) if search_params.present?
      @course_requests = @course_requests.paginate(page: params[:page])
    end

    def accept
    end

    def reject
    end

    private

    def set_manager
      @manager = ::Manager.find(params[:manager_id])
    end

    def course_params
      params.permit(:status, live_studio_courses: [:subject, :grade])
    end
  end
end
