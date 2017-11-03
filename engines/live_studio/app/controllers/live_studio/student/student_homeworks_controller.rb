require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::StudentHomeworksController < Student::BaseController
    layout 'v1/home'

    def index
      @student_homeworks = @student.live_studio_student_homeworks.includes(:homework, :taskable).where(status_params).paginate(page: params[:page])
    end

    private

    def status_params
      params[:status] ||= 'pending'
      { status: LiveStudio::StudentHomework.statuses[params[:status]] }
    end

    def current_resource
      @student ||= ::Student.find(params[:student_id])
    end
  end
end
