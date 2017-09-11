require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::StudentHomeworksController < Student::BaseController
    def index
      @student_homeworks = @student.student_homeworks.where(status_params).paginate(page: params[:page])
    end

    private

    def status_params
      { status: LiveStudio::StudentHomework.statuses[params[:status] || 'pending'] }
    end
  end
end
