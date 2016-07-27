require_dependency "live_studio/application_controller"

module LiveStudio
  class CoursesController < ApplicationController
    before_action :set_student
    before_action :set_course, only: [:show, :play, :publish]
    before_action :play_authorize, only: [:play]

    def index
      @courses = Course.for_sell.includes(:teacher).all
      @tickets = @student.live_studio_tickets.where(course_id: @courses.map(&:id)) if @student.student?
      render layout: "student_home"
    end

    # 开始招生
    def publish
      if @course.init?
        @course.preview!
        LiveService::CourseDirector.new(@course).instance_for_course
      end
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
      @lesson = @course.current_lesson
      @chat_team = @course.chat_team
      # @tickets = @course.tickets.available.includes(:student)
      @teacher = @course.teacher
      @pull_stream = @course.pull_stream
      @chat_account = current_user.chat_account
      @join_record = @chat_team.join_records.find_by(account_id: @chat_account.id) if @chat_team && @chat_account
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
    def set_course
      @course = Course.find(params[:id])
    end

    # 直播授权
    def play_authorize
      redirect_to @course, alert: i18n_failed('have not bought', @course) unless @course.play_authorize(current_user, @lesson)
    end

    def set_student
      @student = ::Student.find_by(id: params[:student_id]) || current_user
    end

    def current_resource
      Course.find(params[:id]) if params[:id]
    end
  end
end
