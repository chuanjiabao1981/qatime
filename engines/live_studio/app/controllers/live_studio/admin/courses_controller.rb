require_dependency "live_studio/manager/base_controller"

module LiveStudio
  module Admin
    class CoursesController < Admin::ApplicationController
      def index
        @courses = LiveStudio::Course.includes(:teacher)
        @courses = @courses.where(@course_search_params) if course_search_params.present?
        @courses = @courses.where("status > ?", LiveStudio::Course.statuses[:init]) if params[:status].blank?
        @courses = @courses.paginate(page: params[:page])
      end

      private

      def course_search_params
        @course_search_params = params.permit(:status, :subject, :grade).select {|_k, v| v.present? }
        @course_search_params[:status] = LiveStudio::Course.statuses[params[:status]] if params[:status].present?
        @course_search_params
      end
    end
  end
end
