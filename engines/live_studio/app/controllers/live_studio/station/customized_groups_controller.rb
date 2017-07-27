require_dependency "live_studio/application_controller"

module LiveStudio
  class Station::CustomizedGroupsController < Station::ApplicationController
    layout 'v1/manager_home'

    def index
      @customized_groups = @workstation.live_studio_customized_groups
      @customized_groups = @customized_groups.uncompleted if params[:hide_completed].present?
      @query = @customized_groups.ransack(params[:q])
      @customized_groups = @query.result.order(id: :desc).paginate(page: params[:page])
    end

    def new
      @customized_group = @workstation.live_studio_customized_groups.new(price: nil, teacher_percentage: nil)
      @customized_group.generate_token
    end

    def create
      @customized_group = @workstation.live_studio_customized_groups.new(group_params)
      if @customized_group.save
        redirect_to live_studio.station_workstation_customized_groups_path(@workstation)
      else
        render :new
      end
    end

    private

    def group_params
      params[:customized_group][:scheduled_lessons_attributes] = params[:customized_group][:scheduled_lessons_attributes].map(&:second) if params[:customized_group] && params[:customized_group][:scheduled_lessons_attributes]
      params[:customized_group][:offline_lessons_attributes] = params[:customized_group][:offline_lessons_attributes].map(&:second) if params[:customized_group] && params[:customized_group][:offline_lessons_attributes]
      params.require(:customized_group).permit(
        :name, :grade, :subject, :objective, :suit_crowd, :description, :token, :teacher_id, :sell_type, :teacher_percentage, :price,
        scheduled_lessons_attributes: [:id, :class_date, :start_at_hour, :start_at_min, :duration, :name, :_destroy],
        offline_lessons_attributes: [:id, :class_date, :start_at_hour, :start_at_min, :duration, :name, :class_address, :_destroy]
      )
    end
  end
end
