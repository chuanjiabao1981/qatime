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

    def play
      @interactive_course = @workstation.live_studio_interactive_courses.find(params[:id])
      @chat_account = current_user.chat_account
      @chat_team = @interactive_course.chat_team
      render layout: 'manager_page'
    end
  end
end
