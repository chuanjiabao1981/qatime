require_dependency "live_studio/application_controller"

module LiveStudio
  class Station::VideoCoursesController < Station::ApplicationController

    def index
      @query = LiveStudio::VideoCourse.published.ransack(params[:q])
      @video_courses = @query.result.order(id: :desc).paginate(page: params[:page])
    end

  end
end
