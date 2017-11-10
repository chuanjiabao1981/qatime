require_dependency "live_studio/application_controller"

module LiveStudio
  class VideoCoursesController < ApplicationController
    layout :current_user_layout
    before_action :set_video_course, only: [:show, :edit, :update, :destroy, :taste, :deliver, :inc_users_count]
    before_action :detect_device_format, only: [:show]

    def index
      @q = LiveService::VideoCourseDirector.search(search_params)
      @courses = @q.result.paginate(page: params[:page], per_page: 12)
      render layout: 'v2/application'
    end

    def show
      @course = LiveStudio::VideoCourse.find(params[:id])

      respond_to do |format|
        format.html do |html|
          html.none { render layout: 'v2/application' }
          html.tablet
          html.phone { render layout: 'application-mobile' }
        end
      end
    end

    def taste
      unless @video_course.taste_tickets.where(student_id: current_user.id).exists?
        LiveService::CourseDirector.taste_course_ticket(current_user, @video_course)
      end
      lesson = VideoLesson.find_by(id: params[:lesson_id]) || @video_course.taste_lesson
      redirect_to live_studio.play_video_lesson_path(lesson)
    end

    def deliver
      @video_course.deliver_free(current_user)
      redirect_to live_studio.video_course_path(@video_course)
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

    def inc_users_count
      @video_course.class.update_counters(@video_course.id, adjust_buy_count: params[:by].to_i)
      @video_course.class.update_counters(@video_course.id, users_count: params[:by].to_i)
      @video_course.reload
    end

    def preview
      @video_course = build_preview_course
      @lessons = @video_course.video_lessons
      @teachers = @video_course.teachers
      render layout: 'v2/application'
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
