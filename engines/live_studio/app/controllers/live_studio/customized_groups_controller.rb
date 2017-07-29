require_dependency "live_studio/application_controller"

module LiveStudio
  class CustomizedGroupsController < ApplicationController
    layout 'v1/application'
    before_action :find_workstation, except: [:index, :show]
    before_action :set_customized_group, only: [:show]

    def index
      @q = LiveService::GroupDirector.search(search_params)
      @customized_groups = @q.result.paginate(page: params[:page], per_page: 12)
    end

    def show
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
