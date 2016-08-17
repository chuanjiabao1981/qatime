require_dependency "live_studio/application_controller"

module LiveStudio
  class CoursesController < ApplicationController
    before_action :set_student
    before_action :set_course, only: [:show, :play, :publish]
    before_action :play_authorize, only: [:play]

    def index
      @courses = LiveService::CourseDirector.courses_search(search_params).paginate(page: params[:page])
      if @student && @student.student?
        @tickets = @student.live_studio_tickets.includes(course: :lesson).where(course_id: @courses.map(&:id)) if @student
      else
        @tickets = Array.new
      end
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
    end

    def update_notice
      @course = Course.find(params[:id])
      @teacher = @course.teacher
      team = @course.chat_team
      attrs = params.require(:team_announcement).permit(:announcement)

      team.team_announcements.create(attrs.merge(edit_at: Time.now))
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
      redirect_to @course, alert: i18n_failed('have not bought', @course) unless @course.play_authorize(current_user, nil)
    end

    def set_student
      @student = ::Student.find_by(id: params[:student_id]) || current_user
    end

    def current_resource
      Course.find(params[:id]) if params[:id]
    end

    def search_params
      flag_params = params.permit(
        :subject, :grade, :class_date_sort, :status, :price_floor,
        :price_ceil,:class_date_floor,:class_date_ceil,:preset_lesson_count_floor,:preset_lesson_count_ceil
      )
      flag_sort = []
      %w(class_date_sort price_sort buy_tickets_count_sort).each do |sort|
        flag_params[sort].present? && flag_sort << "#{sort.gsub('_sort','')}.#{flag_params[sort]}"
        flag_params.delete(sort)
      end
      flag_params[:sort_by] = flag_sort.join('-')
      flag_params
    end
  end
end
