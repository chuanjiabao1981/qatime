require_dependency "live_studio/teacher/base_controller"

module LiveStudio
  class Teacher::InteractiveCoursesController < Teacher::BaseController
    layout 'v1/home'

    def index
      course_data = LiveService::TeacherInteractiveCourseDirector.new(@teacher)
      @interactive_courses = course_data.interactive_courses(params).order(id: :desc).paginate(page: params[:page])
    end

  end
end
