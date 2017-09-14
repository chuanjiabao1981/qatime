require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::QuestionsController < Student::BaseController
    layout 'v1/home'

    def index
      @questions = @student.live_studio_questions.where(status_params).paginate(page: params[:page])
    end

    private

    def status_params
      params[:status] ||= 'pending'
      { status: LiveStudio::Question.statuses[params[:status]] }
    end

    def current_resource
      @student ||= ::Student.find(params[:student_id])
    end
  end
end
