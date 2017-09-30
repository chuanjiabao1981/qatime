require_dependency "live_studio/application_controller"

module LiveStudio
  class Teacher::VideoCoursesController  < Teacher::BaseController
    layout 'v1/home'

    before_action :set_video_course, only: [:show, :edit, :update, :destroy]

    # GET /teacher/video_courses
    def index
      @video_courses = @teacher.live_studio_video_courses.where(status: video_course_cate_filter).paginate(page: params[:page])
    end

    # GET /teacher/video_courses/1
    def show
    end

    # GET /teacher/video_courses/new
    def new
      @video_course = VideoCourse.new(subject: @teacher.subject)
    end

    # GET /teacher/video_courses/1/edit
    def edit
    end

    # POST /teacher/video_courses
    def create
      @video_course = VideoCourse.new(video_course_params)
      @video_course.author = current_user
      @video_course.teacher = @teacher

      if @video_course.save
        @video_course.reset_total_duration
        redirect_to live_studio.teacher_video_courses_path(@teacher), notice: I18n.t("view.notice.create_success", model: @video_course.model_name.human)
      else
        p @video_course.errors
        render :new
      end
    end

    # PATCH/PUT /teacher/video_courses/1
    def update
      if @video_course.update(video_course_params)
        @video_course.reset_total_duration
        # 重新提交审核
        @video_course.submit! if @video_course.rejected?
        redirect_to live_studio.teacher_video_courses_path(@teacher), notice: I18n.t("view.notice.update_success", model: @video_course.model_name.human)
      else
        render :edit
      end
    end

    # DELETE /teacher/video_courses/1
    def destroy
      @video_course.destroy
      redirect_to video_courses_url, notice: I18n.t("view.notice.destroy_success", model: @video_course.model_name.human)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_video_course
        @video_course = VideoCourse.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def video_course_params
        if params[:video_course] && params[:video_course][:video_lessons_attributes].is_a?(Hash)
          params[:video_course][:video_lessons_attributes] = params[:video_course][:video_lessons_attributes].map(&:second)
        end
        params.require(:video_course).permit(:name, :grade, :description,
                                             video_lessons_attributes: [:id, :name, :pos, :real_time, :_destroy, quote_attributes: [:id, :file_id]])
      end

      def video_course_cate_filter
        return VideoCourse.statuses[:published] if 'published' == params[:cate]
        VideoCourse.statuses.values_at(:rejected, :init, :confirmed, :completed)
      end
  end
end
