require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::CoursesController < Student::BaseController

    before_action :courses_chain

    def index
      @courses = courses_chain.paginate(page: params[:page])
    end

    def show
      @course = courses_chain.find(params[:id])
    end

    private

    def courses_chain
      @student = current_user
      @student.live_studio_courses
    end
  end
end
