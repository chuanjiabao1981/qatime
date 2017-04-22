require_dependency "live_studio/application_controller"

module LiveStudio
  class Student::VideoCoursesController < Student::BaseController
    layout 'v1/home'

    # GET /student/video_courses
    def index
      @video_courses = @student.live_studio_video_courses
      ticket_type = params[:cate] == 'tasting' ? "LiveStudio::TasteTicket" : "LiveStudio::BuyTicket"
      @video_courses = @video_courses.where("live_studio_tickets.type = ?", ticket_type)
      @video_courses = @video_courses.paginate(page: params[:page])
    end
  end
end
