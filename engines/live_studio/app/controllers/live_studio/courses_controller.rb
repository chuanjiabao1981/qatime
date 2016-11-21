require_dependency "live_studio/application_controller"

module LiveStudio
  class CoursesController < ApplicationController
    before_action :set_user
    before_action :set_course, only: [:show, :play, :publish, :refresh_current_lesson]
    before_action :play_authorize, only: [:play]

    def index
      @courses = LiveService::CourseDirector.courses_search(search_params).paginate(page: params[:page], per_page: 8)
      if @student && @student.student?
        @tickets = @student.live_studio_tickets.includes(course: :lesson).where(course_id: @courses.map(&:id)) if @student
      else
        @tickets = []
      end
      render layout: 'application_front'
    end

    def new
      @invitation = CourseInvitation.sent.find_by(id: params[:invitation_id]) if params[:invitation_id]
      @course = Course.new(invitation: @invitation)
      5.times { @course.lessons.build }
      render layout: current_user_layout
    end

    def edit
      @course = Course.find(params[:id])
      render layout: current_user_layout
    end

    def create
      @course = Course.new(courses_params.merge(author: current_user))
      if @course.save
        LiveService::ChatAccountFromUser.new(@course.teacher).instance_account
        redirect_to live_studio.send("#{@course.author.role}_courses_path", @course.author)
      else
        render :new, layout: current_user_layout
      end
    end

    # 预览
    def preview
      @course = build_preview_course
      render layout: 'application_front'
    end

    def update
      @course = Course.find(params[:id])

      if @course.update(courses_params)
        LiveService::ChatAccountFromUser.new(@course.teacher).instance_account
        redirect_to live_studio.send("#{@course.author.role}_courses_path", @course.author)
      else
        render :new, layout: current_user_layout
      end
    end

    # 开始招生
    def publish
      if @course.init?
        @course.publish!
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
      render layout: 'application_front'
    end

    def live
    end

    def play
      @chat_team = @course.chat_team
      @current_lesson = @course.current_lesson
      # @tickets = @course.tickets.available.includes(:student)
      @teacher = @course.teacher
      @chat_account = current_user.chat_account
      @join_record = @chat_team.join_records.find_by(account_id: @chat_account.id) if @chat_team && @chat_account
      render layout: 'live'
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

    def set_user
      @teacher = ::Teacher.find_by(id: params[:teacher_id]) || current_user
      @student = ::Student.find_by(id: params[:student_id]) || current_user
    end

    def current_resource
      Course.find(params[:id]) if params[:id]
    end

    def search_params
      params.permit(
        :subject, :grade, :sort_by, :status, :price_floor, :lessons_count_floor, :lessons_count_ceil,
        :price_ceil, :class_date_floor, :class_date_ceil, :preset_lesson_count_floor,:preset_lesson_count_ceil
      )
    end

    def courses_params
      if params[:course] && params[:course][:lessons_attributes]
        params[:course][:lessons_attributes].map do |_, attr|
          attr['class_date'] = attr['start_time'][0,10]
          attr['start_time'] = attr['start_time'][11,8]
          attr['end_time'] = attr['end_time'][11,8]
        end
      end
      params[:course][:lessons_attributes] = params[:course][:lessons_attributes].map(&:second) if params[:course] && params[:course][:lessons_attributes]
      params.require(:course).permit(:name, :grade, :price, :invitation_id, :description, :crop_x, :crop_y, :crop_w, :crop_h, :publicize,
          lessons_attributes: [:id, :name, :class_date, :start_time, :end_time, :_destroy])
    end

    def preview_courses_params
      preview = courses_params
      preview['lessons_attributes'].each do |lesson|
        lesson.delete('id')
      end
      preview
    end

    def build_preview_course
      return Course.find(params[:id]) if params[:id].present?
      course = Course.new(preview_courses_params.merge(author: current_user))
      course.valid?
      course.lessons_count = params[:course][:lessons_attributes].count
      class_dates = params[:course][:lessons_attributes].map {|a| a[:class_date]}.reject(&:blank?)
      @live_start_date = class_dates.min
      @live_end_date = class_dates.max
      course
    end

  end
end
