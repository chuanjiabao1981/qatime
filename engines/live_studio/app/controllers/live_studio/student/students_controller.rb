require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::StudentsController < Student::BaseController
    layout 'v1/home'

    def schedules
      @items = LiveService::ScheduleService.schedule_for(@student).week
      @close_lessons = @items.select { |item| item.target.had_closed? }.sort_by { |item| item.target.start_at }.reverse
      @wait_lessons = @items.select { |item| item.target.unclosed? }.sort_by { |item| item.target.start_at }
    end

    def schedule_data
      @items = LiveService::ScheduleService.schedule_for(@student).month(date_params)
      @items = @items.sort_by { |item| item.target.start_at }
      @date_list = @items.group_by { |item| item.target.class_date.to_s }.keys
      render layout: false
    end

    def settings
      @setting = NotificationSetting.find_by(owner: @student) || NotificationSetting.default
    end

    def tastes
      params[:cate] ||= 'courses'
      student_data = LiveService::StudentLiveDirector.new(@student)
      @taste_courses = student_data.tastes_by(params[:cate]).paginate(page: params[:page])
    end

    def taste_records
      student_data = LiveService::StudentLiveDirector.new(@student)
      @taste_records = student_data.taste_records.paginate(page: params[:page])
    end

    private

    def date_params
      @date_params ||= (params[:date] || Time.now).to_time
    end
  end
end
