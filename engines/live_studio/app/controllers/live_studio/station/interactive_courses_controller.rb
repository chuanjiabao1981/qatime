require_dependency "live_studio/application_controller"

module LiveStudio
  class Station::InteractiveCoursesController < Station::ApplicationController

    def index
      @query = @workstation.live_studio_interactive_courses.ransack(params[:q])
      @interactive_courses = @query.result.paginate(page: params[:page])
    end

  end
end
