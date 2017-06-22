#require_dependency "live_studio/application_controller"
module LiveStudio
  class Teacher::TeachersController < Teacher::BaseController
    layout 'v1/home'

    def schedules
      @items = LiveService::ScheduleService.schedule_for(@teacher).week
      @close_lessons = @items.select(&:unclosed?).sort_by(&:start_at).reverse
      @wait_lessons = @items.select(&:had_closed?).sort_by(&:start_at)
    end

    def schedule_data
      @items = LiveService::ScheduleService.schedule_for(@teacher).month(date_params)
      @items = @items.sort_by(&:start_at)
      @date_list = @items.group_by { |item| item.class_date.to_s }.keys
      render layout: false
    end

    def settings
      @setting = NotificationSetting.find_by(owner: @teacher) || NotificationSetting.default
    end

    private

    def date_params
      @date_params ||= (params[:date] || Time.now).to_time
    end
  end
end
