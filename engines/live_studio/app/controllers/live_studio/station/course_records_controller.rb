require_dependency "live_studio/station/application_controller"

module LiveStudio
  class Station::CourseRecordsController < Station::ApplicationController
    def index
      @q = @workstation.sell_live_studio_courses.includes(:teacher).ransack(search_params[:q])
      @courses = @q.result.paginate(page: params[:page])
      @tickets = @workstation.sell_live_studio_tickets.where(product_type: 'LiveStudio::Course', product_id: @courses.map(&:id))
      @tickets_count = @tickets.select('live_studio_tickets.product_id, count(live_studio_tickets.product_id) as ticket_count')
                               .group('live_studio_tickets.product_id').reorder('live_studio_tickets.product_id')
                               .map {|t| [t.product_id, t.ticket_count]}.to_h
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

    def search_params
      @search_params ||= params.permit(q: [:subject_eq, :grade_eq, :workstation_id_eq])
      @search_params[:q] = {} unless @search_params.key?(:q)
      @search_params
    end
  end
end
