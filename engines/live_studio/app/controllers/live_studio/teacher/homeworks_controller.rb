require_dependency "live_studio/teacher/base_controller"

module LiveStudio
  class Teacher::HomeworksController < Teacher::BaseController
    layout 'v1/home'
    def index
      @homeworks = @teacher.live_studio_homeworks.paginate(page: params[:page])
    end

  end
end
