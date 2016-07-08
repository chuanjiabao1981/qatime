require_dependency "live_studio/application_controller"

module LiveStudio
  class CoursesController < ApplicationController
    before_action :set_student

    def index
      @courses = Course.for_sell.includes(:teacher).all
    end

    def taste
      @course = Course.find(params[:id])
      @course.taste_tickets.find_or_create_by(student: @student)

      @taste_ticket = @course.taste_tickets.find_by(student: @student)

      LiveService::ChatAccountFromUser.new(@student).set_chat_account
    end

    private
    def set_student
      @student = ::Student.find_by(id: params[:student_id]) || current_user
    end
  end
end
