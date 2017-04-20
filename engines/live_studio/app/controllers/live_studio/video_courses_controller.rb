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

    def preview
      @course = build_preview_course
      @lessons = @course.video_lessons
      @teachers = @course.teachers
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

    def build_preview_course
      return VideoCourse.find(params[:id]) if params[:id].present?
      # 二次编辑页面预览
      if params[:edit_id].present?
        course = VideoCourse.find(params[:edit_id])
        course.assign_attributes(video_course_preview_params)
      else
        course = VideoCourse.new(video_course_preview_params)
      end

      course.valid?
      if params[:video_course][:video_lessons_attributes].blank?
        course.video_lessons_count = 0
      else
        course.video_lessons_count = params[:video_course][:video_lessons_attributes].try(:count) || 0
        course.taste_count = course.video_lessons.find_all {|x| x.tastable? }.count
      end
      course
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_video_course
      @video_course = VideoCourse.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def video_course_params
      params.require(:video_course).permit(:name, :grade, :description)
    end

    def video_course_preview_params
      params.require(:video_course).permit(:name, :grade, :description, :objective, :suit_crowd, :sell_type, :price, :teacher_percentage,
                                           video_lessons_attributes: [:id, :tastable])
    end
  end
end
