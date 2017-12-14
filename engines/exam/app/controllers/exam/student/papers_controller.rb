require_dependency "exam/application_controller"

module Exam
  class Student::PapersController < Student::ApplicationController
    # GET /station/papers
    def index
      @tickets = @student.exam_tickets.includes(:product)
      @tickets = @tickets.paginate(page: params[:page])
    end

    private

    def search_params
      params.permit(:status)
    end
  end
end
