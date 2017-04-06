require_dependency "live_studio/application_controller"

module LiveStudio
  class CoursesController < ApplicationController
    before_action :set_user
    before_action :find_workstation, except: [:index, :show]
    before_action :set_course, only: [:show, :play, :publish, :refresh_current_lesson, :live_status]
    before_action :play_authorize, only: [:play]
    before_action :set_city, only: [:index]

    def index
      @q = LiveService::CourseDirector.search(search_params)
      @courses = @q.result.paginate(page: params[:page], per_page: 12)
      preload_tickets(@courses)
      render layout: 'v1/application'
    end

    def new
      @course = Course.new(workstation: @workstation, price: nil, taste_count: nil, teacher_percentage: nil)
      render layout: current_user_layout
    end

    def edit
      @course = Course.find(params[:id])
      render layout: current_user_layout
    end

    def create
      @course = Course.new(courses_params.merge(author: current_user))
      @course.taste_count ||= 0
      if @course.save
        LiveService::ChatAccountFromUser.new(@course.teacher).instance_account rescue nil
        redirect_to live_studio.my_courses_station_workstation_courses_path(@course.workstation)
      else
        render :new, layout: current_user_layout
      end
    end

    # 预览
    def preview
      @course = build_preview_course
      @lessons = @course.new_record? ? @course.lessons : @course.order_lessons
      @teachers = @course.teachers
      render layout: 'v1/application'
    end

    def update
      @course = Course.find(params[:id])

      if @course.update(courses_params)
        LiveService::ChatAccountFromUser.new(@course.teacher).instance_account
        redirect_to live_studio.send("#{@course.teacher.role}_courses_path", @course.teacher)
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
      render layout: 'v1/application'
    end

    def live
    end

    def play
      load_play_data
      @current_lesson = @course.current_lesson
      @teacher = @course.teacher
      render layout: 'v1/live'
    end

    def board
    end

    def camera
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
      @lessons = lesson_map[:lessons].sort_by { |x| x.start_at } if lesson_map.present?
      render partial: 'live_studio/student/students/lesson'
    end

    def live_status
      render json: LiveService::CourseDirector.new(@course).stream_status
    end

    def live_info
      render json: LiveService::RealtimeService.new(params[:id]).live_detail(current_user.try(:id))
    end

    private

    def set_course
      @course = Course.find(params[:id])
    end

    # 直播授权
    def play_authorize
      redirect_to @course, alert: i18n_failed('have_not_bought', @course) unless @course.play_authorize(current_user, nil)
    end

    def load_play_data
      @chat_team = @course.chat_team || LiveService::ChatTeamManager.new(nil).instance_team(@course, @course.teacher.chat_account)
      @chat_account = current_user.try(:chat_account)
      if @chat_account.nil?
        @chat_account = LiveService::ChatAccountFromUser.new(current_user).instance_account
      end
      @join_record = @chat_team.join_records.find_by(account_id: @chat_account.id) || LiveService::ChatTeamManager.new(@chat_team).add_to_team([@chat_account], 'normal').first
    end

    def set_user
      @teacher = ::Teacher.find_by(id: params[:teacher_id]) || current_user
      @student = ::Student.find_by(id: params[:student_id]) || current_user
    end

    def find_workstation
      @workstation ||= current_user.try(:workstations).try(:first) || current_user.try(:workstation)
    end

    def current_resource
      Course.find(params[:id]) if params[:id]
    end

    def search_params
      return @search_params if @search_params.present?
      @search_params = params.permit(:tags, :range, q: [:status, :grade_eq, :subject_eq, :class_date_gteq, :class_date_lt, :s])
      @search_params[:q] ||= {}
      @search_params[:q][:s] ||= "published_at desc"
      @search_params[:q][:status_eq] = LiveStudio::Course.statuses[@search_params[:q][:status]] if @search_params[:q][:status].present?
      @search_params = search_params_filter(@search_params)
    end

    # 搜索参数过滤
    # 不是识别的参数值删除掉
    def search_params_filter(origion_params)
      # 删除不支持的区间查询方式, 影响i18n显示
      origion_params.delete(:range) unless %w(1_months 2_months 3_months 6_months 1_years).include?(origion_params[:range])
      origion_params
    end

    def courses_params
      params[:course][:lessons_attributes] = params[:course][:lessons_attributes].map(&:second) if params[:course] && params[:course][:lessons_attributes]
      params.require(:course).permit(:name, :grade, :subject, :price, :invitation_id, :description, :taste_count, :workstation_id, :tag_list, :objective, :suit_crowd, :teacher_percentage, :teacher_id,
                                     :publicize, :crop_x, :crop_y, :crop_w, :crop_h,
                                     lessons_attributes: [:id, :name, :class_date, :start_time_hour, :start_time_minute, :duration, :_destroy])
    end

    def preview_courses_params
      preview = courses_params
      if preview['lessons_attributes'].respond_to?(:each)
        preview['lessons_attributes'].each { |lesson| lesson.delete('id') }
      end
      preview
    end

    def build_preview_course
      return Course.find(params[:id]) if params[:id].present?
      course = Course.new(preview_courses_params.merge(author: current_user))
      course.valid?
      if params[:course][:lessons_attributes].blank?
        course.lessons_count = 0
        class_dates = []
      else
        course.lessons_count = params[:course][:lessons_attributes].try(:count) || 0
        class_dates = params[:course][:lessons_attributes].map {|a| a[:class_date]}.reject(&:blank?)
      end
      course.start_at, course.end_at = class_dates.min, class_dates.max
      course
    end

    def preload_tickets(courses)
      @tickets =
        if @student && @student.student?
          @student.live_studio_tickets.where(course_id: courses.map(&:id))
        else
          []
        end
    end

  end
end
