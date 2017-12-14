require_dependency "exam/application_controller"

module Exam
  class Student::ApplicationController < ApplicationController
    layout 'v1/home'

    before_action :set_student

    private

    def set_student
      @student ||= ::Student.find(params[:student_id])
      @owner = @student
    end

    def current_resource
      set_student
    end
  end
end
