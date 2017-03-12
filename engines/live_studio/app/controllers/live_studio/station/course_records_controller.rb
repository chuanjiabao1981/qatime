require_dependency "live_studio/station/application_controller"

module LiveStudio
  class Station::CourseRecordsController < Station::ApplicationController

    def index
      @course_records = LiveStudio::Course.includes(:teacher)
      @course_records = @course_records.where(course_search_params) if course_search_params.present?
      @course_records = @course_records.where("live_studio_courses.sell_and_platform_percentage > ?", @workstation.platform_percentage)

      case params[:sell_percentage_range].to_s
        when 'low'
          @course_records = @course_records.where("sell_percentage <= ?", 5)
        when 'middle'
          @course_records = @course_records.where(sell_percentage: [5,10])
        when 'high'
          @course_records = @course_records.where("sell_percentage > ?", 10)
        else
          @course_records
      end
      @course_records = @course_records.where(workstation_id: params[:select_workstation_id]) if params[:select_workstation_id].present?
      @course_records = @course_records.where(status: LiveStudio::Course.statuses.values_at(:published, :teaching)) if params[:status].blank?
      @course_records = @course_records.where(status: LiveStudio::Course.statuses[params[:status].to_s]) if params[:status].present?
      @course_records = @course_records.paginate(page: params[:page])
    end

    def my_publish
      @course_records = LiveStudio::Course.includes(:teacher).where(workstation_id: @workstation.id)
      @course_records = @course_records.where(course_search_params) if course_search_params.present?
      @course_records = @course_records.where(status: LiveStudio::Course.statuses.values_at(:published, :teaching)) if params[:status].blank?
      @course_records = @course_records.where(status: LiveStudio::Course.statuses[params[:status].to_s]) if params[:status].present?
      @course_records = @course_records.paginate(page: params[:page])
    end


    private

    def course_search_params
      params.permit(:subject, :grade).select {|_k, v| v.present? }
    end

  end
end
