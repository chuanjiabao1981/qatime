require_dependency "live_studio/application_controller"

module LiveStudio
  class InteractiveCoursesController < ApplicationController
    layout :current_user_layout

    before_action :find_workstation, except: [:index, :show]
    before_action :find_interactive_course, only: [:destroy, :update_class_date, :update_lessons, :play, :show]
    before_action :play_authorize, only: [:play]

    def index
      @q = LiveService::InteractiveCourseDirector.search(search_params)
      @courses = @q.result.paginate(page: params[:page], per_page: 12)
      render layout: 'v2/application'
    end

    def show
      render layout: 'v2/application'
    end

    def interactive
      @interactive_course = LiveStudio::InteractiveCourse.find(params[:id])
      @course = @interactive_course
      render layout: 'v1/live'
    end

    def new
      @interactive_course = InteractiveCourse.new(workstation: @workstation, price: nil, teacher_percentage: nil)
      render layout: 'v1/manager_home'
    end

    def create
      @interactive_course = InteractiveCourse.new(interactive_courses_params)
      @interactive_course.author = current_user
      if @interactive_course.save
        # LiveService::ChatAccountFromUser.new(@course.teacher).instance_account
        redirect_to live_studio.station_workstation_interactive_courses_path(@interactive_course.workstation)
      else
        render :new, layout: 'v1/manager_home'
      end
    end

    def destroy
      if @interactive_course.init?
        @interactive_course.destroy
      end
      redirect_to live_studio.station_workstation_interactive_courses_path(@interactive_course.workstation)
    end

    # 预览
    def preview
      @interactive_course = build_preview_course
      @lessons = @interactive_course.new_record? ? @interactive_course.interactive_lessons : @interactive_course.order_lessons
      @teachers = @interactive_course.new_record? ? @interactive_course.interactive_lessons.map(&:teacher).uniq.compact : @interactive_course.teachers
      render layout: 'v2/application'
    end

    # 调课
    def update_class_date
      render layout: 'v1/manager_home'
    end

    def update_lessons
      # 课程更新 全部更新时间戳 render error时可以重新编辑
      @interactive_course.interactive_lessons.map(&:touch)
      if @interactive_course.update(interactive_lessons_params)
        @interactive_course.ready_lessons
        redirect_to live_studio.station_workstation_interactive_courses_path(@interactive_course.workstation)
      else
        render :update_class_date, layout: 'v1/manager_home'
      end
    end

    def play
      load_play_data
      @course = @interactive_course
      @teachers = @interactive_course.teachers
      @current_lesson = @interactive_course.current_lesson
      @current_teacher = @current_lesson.teacher || @teachers.first
      render layout: 'v1/live'
    end

    def live_info
      render json: LiveService::InteractiveRealtimeService.new(params[:id]).live_detail(current_user.try(:id))
    end

    private

    def search_params
      return @search_params if @search_params.present?
      @search_params ||= params.permit(q: [:grade_eq, :subject_eq, :s])
      @search_params[:q] ||= {}
      @search_params[:q][:s] ||= 'published_at desc'
      @search_params
    end

    def find_workstation
      if params[:workstation_id].present?
        @workstation = ::Workstation.find(params[:workstation_id])
      end
      @workstation ||= current_user.try(:workstations).try(:first) || current_user.try(:workstation)
    end

    def current_resource
      find_workstation
    end

    def find_interactive_course
      @interactive_course = InteractiveCourse.find(params[:id])
    end

    def interactive_courses_params
      params[:interactive_course][:interactive_lessons_attributes] = params[:interactive_course][:interactive_lessons_attributes].map(&:second) if params[:interactive_course] && params[:interactive_course][:interactive_lessons_attributes]
      params.require(:interactive_course).permit(:name, :grade, :subject, :price, :teacher_percentage, :description, :objective, :suit_crowd, :taste_count, :workstation_id, :publicize, :crop_x, :crop_y, :crop_w, :crop_h,
                                                 interactive_lessons_attributes: [:id, :name, :class_date, :teacher_id, :start_time_hour, :start_time_minute, :duration, :_destroy])
    end

    def interactive_lessons_params
      params.require(:interactive_course).permit(interactive_lessons_attributes: [:id, :duration, :class_date, :teacher_id, :start_time_hour, :start_time_minute, :_update])
    end

    def preview_courses_params
      preview = interactive_courses_params
      if preview['interactive_lessons_attributes'].respond_to?(:each)
        preview['interactive_lessons_attributes'].each { |lesson| lesson.delete('id') }
      end
      preview
    end

    def build_preview_course
      return InteractiveCourse.find(params[:id]) if params[:id].present?
      course = InteractiveCourse.new(preview_courses_params.merge(author: current_user))
      course.valid?
      lesson_params = params[:interactive_course][:interactive_lessons_attributes].reject {|x| x['_destroy'] == '1'} rescue []
      if lesson_params.blank?
        course.interactive_lessons_count = 0
        class_dates = []
      else
        course.interactive_lessons_count = lesson_params.try(:count) || 0
        class_dates = lesson_params.map { |a| a[:class_date] if a[:_destroy] == '0' }.reject(&:blank?)
      end
      course.class_date, course.start_at, course.end_at = class_dates.min, class_dates.min, class_dates.max
      course
    end

    def load_play_data
      @chat_team = @interactive_course.chat_team || LiveService::ChatTeamManager.new(nil).instance_team(@interactive_course, @interactive_course.teacher.chat_account)
      @chat_account = current_user.try(:chat_account)
      if @chat_account.nil?
        @chat_account = LiveService::ChatAccountFromUser.new(current_user).instance_account
      end
      @join_record = @chat_team.join_records.find_by(account_id: @chat_account.id) || LiveService::ChatTeamManager.new(@chat_team).add_to_team([@chat_account], 'normal').first
    end

    # 直播授权
    def play_authorize
      redirect_to @interactive_course, alert: i18n_failed('have_not_bought', @interactive_course) unless @interactive_course.play_authorize(current_user, nil)
    end

  end
end
