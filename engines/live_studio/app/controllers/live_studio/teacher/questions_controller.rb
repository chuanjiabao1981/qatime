require_dependency "live_studio/teacher/base_controller"

module LiveStudio
  class Teacher::QuestionsController < Teacher::BaseController
    layout 'v1/home'

    def index
      @questions = @teacher.live_studio_questions.where(status_params).paginate(page: params[:page])
    end

    private

    def status_params
      params[:status] ||= 'pending'
      { status: LiveStudio::Question.statuses[params[:status]] }
    end

    def current_resource
      @teacher ||= ::Teacher.find(params[:teacher_id])
    end
  end
end
