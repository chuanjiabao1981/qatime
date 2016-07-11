require_dependency "live_studio/application_controller"

module LiveStudio
  class CoursesController < ApplicationController
    before_action :set_student

    def index
      @courses = Course.for_sell.includes(:teacher).all
      @tickets = @student.live_studio_tickets.where(course_id: @courses.map(&:id)) if @student.student?
    end

    def taste
      @course = Course.find(params[:id])
      @course.taste_tickets.find_or_create_by(student: @student)

      @taste_ticket = @course.taste_tickets.find_by(student: @student)

      LiveService::ChatAccountFromUser.new(@student).set_chat_account
    end

    def show
      @course = Course.find(params[:id])
    end

    def live
    end

    def play
      @course = Course.find(params[:id])
      @chat_team = @course.chat_team
      # @tickets = @course.tickets.available.includes(:student)
      @lesson = @course.current_lesson
      @teacher = @course.teacher
      @pull_stream = @course.pull_stream
      @chat_account = current_user.chat_account
    end

    private
    # 直播授权
    def play_authorize
    end

    def set_student
      @student = ::Student.find_by(id: params[:student_id]) || current_user
    end
  end
end
