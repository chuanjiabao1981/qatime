require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::CoursesController < Student::BaseController
    def index
      @tickets = current_user.live_studio_tickets.visiable.includes(course: :teacher)
    end

    def show
      @ticket = current_user.live_studio_tickets.visiable.find_by(course_id: params[:id])
      @course = @ticket.course
    end
  end
end
