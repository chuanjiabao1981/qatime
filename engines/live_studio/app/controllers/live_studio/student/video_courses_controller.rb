require_dependency "live_studio/application_controller"

module LiveStudio
  class Student::VideoCoursesController < Student::BaseController
    layout 'v1/home'

    def index
      params[:cate] ||= 'charge'
      course_data = LiveService::StudentLiveDirector.new(@student)
      @video_courses = course_data.video_courses(sell_type: params[:cate]).paginate(page: params[:page])
    end
  end
end
