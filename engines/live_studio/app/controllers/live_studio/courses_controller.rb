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

      LiveService::ChatAccountFromUser.new(@student).instance_account
    end

    def show
      @course = Course.find(params[:id])
      @lessons = @course.lessons.paginate(page: params[:page])
    end

    def live
    end

    def play
      @course = Course.find(params[:id])
      @lesson = @course.current_lesson
      redirect_to @course, alert: i18n_failed('today_has_no_lesson', @course) if @lesson.nil?
      @chat_team = @course.chat_team
      # @tickets = @course.tickets.available.includes(:student)
      @teacher = @course.teacher
      @pull_stream = @course.pull_stream
      @chat_account = current_user.chat_account
    end

    def update_notice
      @course = Course.find(params[:id])
      @teacher = @course.teacher
      team = @course.chat_team
      attrs = params.require(:team).permit(:announcement)

      team.update_columns(attrs)
      team.reload
      Chat::IM.team_update(tid: team.team_id, owner: team.owner, announcement: team.announcement)

      redirect_to teacher_course_path(@teacher, @course)
    end

    private
    # 直播授权
    def play_authorize
      @paly_record = @course.play_authorize(current_user, @lesson)
      redirect_to @course, alert: i18n_failed('have not bought', @course) if @paly_record.nil?
    end

    def set_student
      @student = ::Student.find_by(id: params[:student_id]) || current_user
    end

    def current_resource
      Course.find(params[:id]) if params[:id]
    end
  end
end
