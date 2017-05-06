require_dependency "live_studio/teacher/base_controller"

module LiveStudio
  class Teacher::InteractiveCoursesController < Teacher::BaseController
    layout 'v1/home'

    def index
      @interactive_courses = @teacher.live_studio_interactive_courses
      @interactive_courses = @interactive_courses.where(status: LiveStudio::InteractiveCourse.statuses[params[:status]]) if params[:status].present?
      @interactive_courses = @interactive_courses.order(id: :desc).paginate(page: params[:page])
    end
  end
end
