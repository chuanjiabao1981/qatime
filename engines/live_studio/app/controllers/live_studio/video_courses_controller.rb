require_dependency "live_studio/application_controller"

module LiveStudio
  class VideoCoursesController < ApplicationController
    layout :current_user_layout

    def index
      @q = LiveService::VideoCourseDirector.search(search_params)
      @courses = @q.result.paginate(page: params[:page], per_page: 12)
      render layout: 'v1/application'
    end

    def show
      @course = LiveStudio::VideoCourse.find(params[:id])
      render layout: 'v1/application'
    end

    private

    def search_params
      return @search_params if @search_params.present?
      @search_params ||= params.permit(q: [:grade_eq, :subject_eq, :sell_type_eq, :s])
      @search_params[:q] ||= {}
      @search_params[:q][:s] ||= 'published_at desc'
      @search_params
    end

  end
end
