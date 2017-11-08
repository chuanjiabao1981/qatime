require_dependency "live_studio/application_controller"

module LiveStudio
  class CustomizedGroupsController < ApplicationController
    layout 'v2/application'
    before_action :find_workstation, except: [:index, :show]
    before_action :set_customized_group, only: [:show, :for_free, :play, :inc_users_count]
    before_action :play_authorize, only: [:play]

    def index
      @q = LiveService::GroupDirector.search(search_params)
      @customized_groups = @q.result.paginate(page: params[:page], per_page: 12)
    end

    def show
      @quotes = @customized_group.quotes.includes(:file).order(created_at: :desc)
    end

    # 免费上课
    def for_free
      @customized_group.free_grant(current_user) if current_user.student?
      redirect_to live_studio.customized_group_path(@customized_group)
    end

    def preview
      @customized_group = build_preview_group
      @teachers = @customized_group.teachers
    end

    def play
      load_play_data
      @current_lesson = @customized_group.current_event
      @teacher = @customized_group.teacher
      render layout: 'v1/live'
    end

    def live_info
      render json: LiveService::GroupRealtimeService.new(params[:id]).live_detail(current_user.try(:id))
    end

    # 调整报名人数
    def inc_users_count
      @customized_group.adjust_users(params[:by].to_i)
      @customized_group.reload
    end

    private

    # 直播授权
    def play_authorize
      redirect_to @customized_group, alert: i18n_failed('have_not_bought', @customized_group) unless @customized_group.play_authorize(current_user, nil)
    end

    def load_play_data
      @chat_team = @customized_group.chat_team || LiveService::ChatTeamManager.new(nil).instance_team(@customized_group, @customized_group.teacher.chat_account)
      @chat_account = current_user.try(:chat_account)
      if @chat_account.nil?
        @chat_account = LiveService::ChatAccountFromUser.new(current_user).instance_account
      end
      @join_record = @chat_team.join_records.find_by(account_id: @chat_account.id) || LiveService::ChatTeamManager.new(@chat_team).add_to_team([@chat_account], 'normal').first
    end

    def search_params
      return @search_params if @search_params.present?
      @search_params = params.permit(:range, q: [:status, :sell_type_eq, :grade_eq, :subject_eq, :start_at_gteq, :start_at_lt, :s])
      @search_params[:q] ||= {}
      @search_params[:q][:s] ||= "published_at desc"
      @search_params[:q][:status_eq] = LiveStudio::CustomizedGroup.statuses[@search_params[:q][:status]] if @search_params[:q][:status].present?
      @search_params = search_params_filter(@search_params)
    end

    # 搜索参数过滤
    # 不是识别的参数值删除掉
    def search_params_filter(origion_params)
      # 删除不支持的区间查询方式, 影响i18n显示
      origion_params.delete(:range) unless %w(1_months 2_months 3_months 6_months 1_years).include?(origion_params[:range])
      origion_params
    end

    def group_params
      params[:customized_group][:scheduled_lessons_attributes] = params[:customized_group][:scheduled_lessons_attributes].map(&:second) if params[:customized_group] && params[:customized_group][:scheduled_lessons_attributes]
      params[:customized_group][:offline_lessons_attributes] = params[:customized_group][:offline_lessons_attributes].map(&:second) if params[:customized_group] && params[:customized_group][:offline_lessons_attributes]
      params.require(:customized_group).permit(
          :name, :grade, :subject, :objective, :suit_crowd, :description, :token, :teacher_id, :sell_type, :teacher_percentage, :price,
          scheduled_lessons_attributes: [:id, :class_date, :start_at_hour, :start_at_min, :duration, :name, :_destroy],
          offline_lessons_attributes: [:id, :class_date, :start_at_hour, :start_at_min, :duration, :name, :class_address, :_destroy]
      )
    end

    def preview_group_params
      preview = group_params
      if preview['scheduled_lessons_attributes'].respond_to?(:each)
        preview['scheduled_lessons_attributes'].each { |lesson| lesson.delete('id') }
      end
      if preview['offline_lessons_attributes'].respond_to?(:each)
        preview['offline_lessons_attributes'].each { |lesson| lesson.delete('id') }
      end
      preview
    end

    def build_preview_group
      return CustomizedGroup.find(params[:id]) if params[:id].present?
      course = @workstation.live_studio_customized_groups.new(preview_group_params.merge(author: current_user))
      course.valid?
      class_dates = []

      schedule_lesson_params = params[:customized_group][:scheduled_lessons_attributes].reject {|x| x['_destroy'] == '1'} rescue []
      offline_lesson_params = params[:customized_group][:offline_lessons_attributes].reject {|x| x['_destroy'] == '1'} rescue []

      if schedule_lesson_params.blank? && offline_lesson_params.blank?
        course.events_count = 0
      else
        course.events_count = schedule_lesson_params.try(:count).to_i + offline_lesson_params.try(:count).to_i
        class_dates += schedule_lesson_params.map {|a| a[:class_date]}.reject(&:blank?) if schedule_lesson_params
        class_dates += offline_lesson_params.map {|a| a[:class_date]}.reject(&:blank?) if offline_lesson_params
      end
      course.start_at, course.end_at = class_dates.min, class_dates.max
      course
    end

    def set_customized_group
      @customized_group = CustomizedGroup.find(params[:id])
    end

    def find_workstation
      if params[:workstation_id].present?
        @workstation = ::Workstation.find(params[:workstation_id])
      end
      @workstation ||= current_user.try(:workstations).try(:first) || current_user.try(:workstation)
    end

    def current_resource
      CustomizedGroup.find(params[:id]) if params[:id]
    end
  end
end
