require_dependency "exam/application_controller"

module Exam
  class Student::ResultsController < Student::ApplicationController
    # GET /station/papers
    def index
      @results = @student.exam_results.includes(:paper)
      @results = @results.paginate(page: params[:page])
    end

    private

    def search_params
      params.permit(:status)
    end
  end
end
