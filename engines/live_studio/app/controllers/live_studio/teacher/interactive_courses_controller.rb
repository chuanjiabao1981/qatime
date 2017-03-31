require_dependency "live_studio/teacher/base_controller"

module LiveStudio
  class Teacher::InteractiveCoursesController < Teacher::BaseController
    layout 'teacher_home_new'

    def index
      @courses = @teacher.live_studio_interactive_courses
      @courses = @courses.where(status: LiveStudio::InteractiveCourse.statuses[params[:status]]) if params[:status].present?
      @courses = @courses.order(id: :desc).paginate(page: params[:page])
    end
  end
end
