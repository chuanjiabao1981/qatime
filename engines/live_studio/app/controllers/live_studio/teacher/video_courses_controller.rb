require_dependency "live_studio/application_controller"

module LiveStudio
  class Teacher::VideoCoursesController  < Teacher::BaseController
    layout 'v1/home'

    before_action :set_video_course, only: [:show, :edit, :update, :destroy]

    # GET /teacher/video_courses
    def index
      @video_courses = VideoCourse.all.where(status: video_course_status_filter).paginate(page: params[:page])
    end

    # GET /teacher/video_courses/1
    def show
    end

    # GET /teacher/video_courses/new
    def new
      @video_course = VideoCourse.new
    end

    # GET /teacher/video_courses/1/edit
    def edit
    end

    # POST /teacher/video_courses
    def create
      @video_course = VideoCourse.new(video_course_params)

      if @video_course.save
        redirect_to @video_course, notice: 'Video course was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /teacher/video_courses/1
    def update
      if @video_course.update(video_course_params)
        redirect_to @video_course, notice: 'Video course was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /teacher/video_courses/1
    def destroy
      @video_course.destroy
      redirect_to video_courses_url, notice: 'Video course was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_video_course
        @video_course = VideoCourse.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def video_course_params
        params.require(:video_course).permit(:name, :grade, :description)
      end

      def video_course_status_filter
        return VideoCourse.statuses[:init] if params[:status].blank?
        VideoCourse.statuses.values_at(:published, :completed, :confirmed)
      end
  end
end
