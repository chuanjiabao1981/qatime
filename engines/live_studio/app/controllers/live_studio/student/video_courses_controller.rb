require_dependency "live_studio/application_controller"

module LiveStudio
  class Student::VideoCoursesController < Student::BaseController
    layout 'v1/home'

    # GET /student/video_courses
    def index
      @video_courses = @student.live_studio_video_courses.where("live_studio_tickets.type = ?", 'LiveStudio::BuyTicket').paginate(page: params[:page])
    end
  end
end
