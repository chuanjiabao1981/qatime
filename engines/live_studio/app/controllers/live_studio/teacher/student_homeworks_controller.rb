require_dependency "live_studio/teacher/base_controller"

module LiveStudio
  class Teacher::StudentHomeworksController < Teacher::BaseController
    layout 'v1/home'
    def index
      @student_homeworks = @teacher.live_studio_student_homeworks.where(status_params).paginate(page: params[:page])
    end

    private

    def status_params
      { status: LiveStudio::StudentHomework.statuses[params[:status] || 'submitted'] }
    end
  end
end
