require_dependency "live_studio/application_controller"

module LiveStudio
  class Station::InteractiveCoursesController < Station::ApplicationController
    layout 'v1/manager_home'

    def index
      @interactive_courses = @workstation.live_studio_interactive_courses
      @interactive_courses = @interactive_courses.uncompleted if params[:hide_completed].present?
      @query = @interactive_courses.ransack(params[:q])
      @interactive_courses = @query.result.order(id: :desc).paginate(page: params[:page])
    end
  end
end
