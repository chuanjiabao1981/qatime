require_dependency "live_studio/application_controller"

module LiveStudio
  class CoursesController < ApplicationController
    before_action :set_student
    before_action :set_course, only: [:show, :play, :publish, :refresh_current_lesson]
    before_action :play_authorize, only: [:play]

    def index
      @courses = LiveService::CourseDirector.courses_search(search_params).paginate(page: params[:page])
      if @student && @student.student?
        @tickets = @student.live_studio_tickets.includes(course: :lesson).where(course_id: @courses.map(&:id)) if @student
      else
        @tickets = []
      end
    end

    def new
      @course = Course.new
      render layout: current_user_layout
    end

    def edit
      @course = Course.find(params[:id])
      render layout: current_user_layout
    end

    def create
      @course = Course.new(courses_params.merge(author: current_user))
      if current_user.teacher?
        @course.teacher = current_user
        @course.teacher_percentage = 100
      end
      if @course.save
        redirect_to live_studio.course_path(@course)
      else
        render :new
      end
    end

    def update
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
      @taste_ticket = LiveService::CourseDirector.taste_course_ticket(@student, @course)
    end

    def show
      @course = Course.find(params[:id])
      @lessons = @course.lessons.paginate(page: params[:page])
    end

    def live
    end

    def play
      @chat_team = @course.chat_team
      @current_lesson = @course.current_lesson
      # @tickets = @course.tickets.available.includes(:student)
      @teacher = @course.teacher
      @pull_stream = @course.pull_stream
      @chat_account = current_user.chat_account
      @join_record = @chat_team.join_records.find_by(account_id: @chat_account.id) if @chat_team && @chat_account
      render layout: 'play'
    end

    def refresh_current_lesson
      @current_lesson = @course.current_lesson
    end

    def update_notice
      @course = Course.find(params[:id])
      @teacher = @course.teacher
      team = @course.chat_team
      attrs = params.require(:team_announcement).permit(:announcement)

      team.team_announcements.create(attrs.merge(edit_at: Time.now))
      team.reload
      Chat::IM.team_update(tid: team.team_id, owner: team.owner, announcement: team.announcement)

      # 发送通知消息
      LiveService::CourseNotificationSender.new(@course).notice(LiveStudioCourseNotification::ACTION_NOTICE_CREATE)
      redirect_to teacher_course_path(@teacher, @course)
    end

    def schedule_sources
      @user = User.find(params[:user_id])
      moment = params[:date].blank? ? Time.now : params[:date].to_time
      arr = LiveService::CourseDirector.courses_by_month(@user, moment)
      @date_list = arr.map{|data| data[:date]}
      lesson_map = arr.select{|data| data[:date].to_time == moment}.first
      @lessons = lesson_map[:lessons] if lesson_map.present?
      render partial: 'live_studio/student/students/lesson'
    end

    private

    def set_course
      @course = Course.find(params[:id])
    end

    # 直播授权
    def play_authorize
      redirect_to @course, alert: i18n_failed('have_not_bought', @course) unless @course.play_authorize(current_user, nil)
    end

    def set_student
      @student = ::Student.find_by(id: params[:student_id]) || current_user
    end

    def current_resource
      Course.find(params[:id]) if params[:id]
    end

    def search_params
      params.permit(
        :subject, :grade, :sort_by, :status, :price_floor,
        :price_ceil,:class_date_floor,:class_date_ceil,:preset_lesson_count_floor,:preset_lesson_count_ceil
      )
    end

    def courses_params(role = nil)
      role_params = [:name, :price, :preset_lesson_count, :subject, :grade, :publicize, :taste_count, :description]
      role_params = role_params << [:teacher_percentage, :workstation_id, :teacher_id] unless role == :teacher
      params.require(:course).permit(role_params)
    end
  end
end
