require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::InteractiveCoursesController < Student::BaseController
    layout 'student_home_new'

    def index
      @courses = LiveService::StudentLiveDirector.new(@student).interactive_courses(params)
      @courses = @courses.includes(:interactive_lessons).paginate(page: params[:page])
    end
  end
end
