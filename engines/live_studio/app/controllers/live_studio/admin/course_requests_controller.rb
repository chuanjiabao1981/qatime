module LiveStudio
  module Admin
    class CourseRequestsController < Admin::ApplicationController
      def index
        # 只有一个工作站
        @course_requests = LiveStudio::CourseRequest.includes(:course)
        @course_requests = 'handled' == params[:status] ? @course_requests.handled : @course_requests.submitted
        @course_requests = @course_requests.where(live_studio_courses: course_search_params) if course_search_params.present?
        @course_requests = @course_requests.paginate(page: params[:page])
      end

      def accept
        @course_request.accept!
        redirect_to live_studio.admin_course_requests_path
      end

      def reject
        @course_request.reject!
        redirect_to live_studio.admin_course_requests_path
      end

      private

      def set_course_request
        @course_request = LiveStudio::CourseRequest.find(params[:id])
      end

      def course_search_params
        @course_search_params = params.permit(:subject, :grade).select {|_k, v| v.present? }
      end
    end
  end
end
