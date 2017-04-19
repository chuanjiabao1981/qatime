require_dependency "live_studio/application_controller"

module LiveStudio
  class VideoCoursesController < ApplicationController
    layout :current_user_layout
    before_action :set_video_course, only: [:show, :edit, :update, :destroy]

    def index
      @q = LiveService::VideoCourseDirector.search(search_params)
      @courses = @q.result.paginate(page: params[:page], per_page: 12)
      render layout: 'v1/application'
    end

    def show
      @course = LiveStudio::VideoCourse.find(params[:id])
      render layout: 'v1/application'
    end

    def taste
      @course = VideoCourse.find(params[:id])
      @taste_ticket = LiveService::CourseDirector.taste_course_ticket(current_user, @course)
    end

    # GET /video_courses/new
    def new
      @video_course = VideoCourse.new
    end

    # GET /video_courses/1/edit
    def edit
    end

    # POST /video_courses
    def create
      @video_course = VideoCourse.new(video_course_params)

      if @video_course.save
        redirect_to @video_course, notice: 'Video course was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /video_courses/1
    def update
      if @video_course.update(video_course_params)
        redirect_to @video_course, notice: 'Video course was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /video_courses/1
    def destroy
      @video_course.destroy
      redirect_to video_courses_url, notice: 'Video course was successfully destroyed.'
    end

    private

    def search_params
      return @search_params if @search_params.present?
      @search_params ||= params.permit(q: [:grade_eq, :subject_eq, :sell_type_eq, :s])
      @search_params[:q] ||= {}
      @search_params[:q][:s] ||= 'published_at desc'
      @search_params
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_video_course
      @video_course = VideoCourse.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def video_course_params
      params.require(:video_course).permit(:name, :grade, :description)
    end
  end
end
