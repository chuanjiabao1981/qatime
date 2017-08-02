require_dependency "live_studio/application_controller"

module LiveStudio
  class CustomizedGroupsController < ApplicationController
    layout 'v1/application'
    before_action :find_workstation, except: [:index, :show]
    before_action :set_customized_group, only: [:show, :for_free]

    def index
      @q = LiveService::GroupDirector.search(search_params)
      @customized_groups = @q.result.paginate(page: params[:page], per_page: 12)
    end

    def show
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

    private

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

      if params[:customized_group][:scheduled_lessons_attributes].blank? && params[:customized_group][:offline_lessons_attributes].blank?
        course.events_count = 0
      else
        course.events_count = params[:customized_group][:scheduled_lessons_attributes].try(:count).to_i + params[:customized_group][:offline_lessons_attributes].try(:count).to_i
        class_dates += params[:customized_group][:scheduled_lessons_attributes].map {|a| a[:class_date]}.reject(&:blank?) if params[:customized_group][:scheduled_lessons_attributes]
        class_dates += params[:customized_group][:offline_lessons_attributes].map {|a| a[:class_date]}.reject(&:blank?) if params[:customized_group][:offline_lessons_attributes]
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
