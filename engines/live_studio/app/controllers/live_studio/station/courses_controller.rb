require_dependency "live_studio/station/application_controller"

module LiveStudio
  class Station::CoursesController < Station::ApplicationController
    def index
      @courses = @workstation.live_studio_courses.includes(:teacher).where(course_search_params).paginate(page: params[:page])
    end

    private

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
