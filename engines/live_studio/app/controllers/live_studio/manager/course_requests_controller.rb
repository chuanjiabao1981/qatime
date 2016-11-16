require_dependency "live_studio/manager/base_controller"

module LiveStudio
  class Manager::CourseRequestsController < Manager::BaseController
    before_action :set_manager
    before_action :set_course_request, only: [:accept, :reject]

    def index
      # 只有一个工作站
      @course_requests = @manager.course_requests.includes(:course)
      @course_requests = 'handled' == params[:status] ? @course_requests.handled : @course_requests.submitted
      @course_requests = @course_requests.where(live_studio_courses: course_search_params) if course_search_params.present?
      @course_requests = @course_requests.paginate(page: params[:page])
    end

    def accept
      @course_request.accept!
    end

    def reject
      @course_request.reject!
    end

    private

    def set_manager
      @manager = ::Manager.find(params[:manager_id])
    end

    def set_course_request
      @course_request = @manager.course_requests.find(params[:id])
    end

    def course_search_params
      @course_search_params = params.permit(:subject, :grade).select {|_k, v| v.present? }
    end
  end
end
