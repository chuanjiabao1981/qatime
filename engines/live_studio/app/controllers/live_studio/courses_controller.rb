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

      # 生成course_action_record,给学生发送提示
      course_action_record = @course.course_action_records.new(
        content: I18n.t(
          "activerecord.view.course_action_record.content.notice_update_for_students",
          course_name: course.name
        ),
        category: :notice_update_for_students,
        live_studio_course_id: course.id,
        live_studio_lesson_id: id
      )
      course_action_record.save(validate: false)

      LiveService::CourseActionRecordDirector.new(course_action_record).create_action_notification

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
      redirect_to @course, alert: i18n_failed('have not bought', @course) unless @course.play_authorize(current_user, nil)
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
      # flag_sort = []
      # %w(class_date_sort price_sort lesson_count_sort).each do |sort|
      #   flag_params[sort].present? && flag_sort << "#{sort.gsub('_sort','')}.#{flag_params[sort]}"
      #   flag_params.delete(sort)
      # end
      # flag_params[:sort_by] = flag_sort.join('-')
      # flag_params
    end
  end
end
