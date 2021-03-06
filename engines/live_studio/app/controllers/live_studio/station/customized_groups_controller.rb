require_dependency "live_studio/application_controller"

module LiveStudio
  class Station::CustomizedGroupsController < Station::ApplicationController
    layout 'v1/manager_home'

    before_action :set_customized_group, only: [:update_class_date, :update_lessons, :send_qr_code]

    def index
      @customized_groups = @workstation.live_studio_customized_groups
      @customized_groups = @customized_groups.uncompleted if params[:hide_completed].present?
      @query = @customized_groups.ransack(params[:q])
      @customized_groups = @query.result.order(id: :desc).paginate(page: params[:page])
    end

    # 代销列表
    def sells_list
      @query = LiveStudio::CustomizedGroup.published.sell_and_platform_percentage_greater_than(@workstation.platform_percentage).ransack(params[:q])
      @customized_groups = @query.result.includes(:teacher, :workstation, :events).order(id: :desc).paginate(page: params[:page])
    end

    def new
      @customized_group = @workstation.live_studio_customized_groups.new(price: nil, teacher_percentage: nil, max_users: nil)
      @customized_group.generate_token
    end

    def create
      @customized_group = @workstation.live_studio_customized_groups.new(group_params)
      if @customized_group.save
        redirect_to live_studio.station_workstation_customized_groups_path(@workstation)
      else
        p  @customized_group.errors
        render :new
      end
    end

    def update_class_date
    end

    def update_lessons
      # 课程更新 全部更新时间戳 render error时可以重新编辑
      @customized_group.scheduled_lessons.map(&:touch)
      @customized_group.offline_lessons.map(&:touch)
      if @customized_group.update(events_params)
        @customized_group.ready_lessons
        redirect_to live_studio.station_workstation_customized_groups_path(@customized_group.workstation)
      else
        render :update_class_date
      end
    end

    # 发送二维码
    def send_qr_code
      code = @workstation.coupon.try(:code)
      return render text: I18n.t('view.live_studio/courses.no_coupon_code') if code.blank?

      qr_code_url = @customized_group.generate_qrcode_by_coupon(code)
      image = URI(qr_code_url).read
      send_data image, type: "#{image.content_type};charset=utf-8;header=present", filename: "#{@customized_group.name.to_s}.png", disposition: 'attachment'
    end

    private

    def set_customized_group
      @customized_group = CustomizedGroup.find(params[:id])
    end

    def group_params
      params[:customized_group][:scheduled_lessons_attributes] = params[:customized_group][:scheduled_lessons_attributes].map(&:second) if params[:customized_group] && params[:customized_group][:scheduled_lessons_attributes]
      params[:customized_group][:offline_lessons_attributes] = params[:customized_group][:offline_lessons_attributes].map(&:second) if params[:customized_group] && params[:customized_group][:offline_lessons_attributes]
      params.require(:customized_group).permit(
        :name, :grade, :subject, :objective, :suit_crowd, :description, :token, :max_users, :teacher_id, :sell_type, :teacher_percentage, :price,
        scheduled_lessons_attributes: [:id, :class_date, :start_at_hour, :start_at_min, :duration, :name, :_destroy],
        offline_lessons_attributes: [:id, :class_date, :start_at_hour, :start_at_min, :duration, :name, :class_address, :_destroy]
      )
    end

    def events_params
      params.require(:customized_group).permit(
        scheduled_lessons_attributes: [:id, :duration, :class_date, :start_at_hour, :start_at_min, :_update],
        offline_lessons_attributes: [:id, :duration, :class_date, :start_at_hour, :start_at_min, :_update]
      )
    end
  end
end
