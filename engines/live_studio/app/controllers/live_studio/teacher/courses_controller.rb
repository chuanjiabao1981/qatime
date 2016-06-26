require_dependency "live_studio/teacher/base_controller"

module LiveStudio
  class Teacher::CoursesController < Teacher::BaseController

    before_action :courses_chain
    before_action :set_course, only: [:show, :edit, :update, :destroy, :channel]

    def index
      @courses = courses_chain.paginate(page: params[:page])

    end

    def show
    end

    def edit
    end

    # PATCH/PUT /teacher/courses/1
    def update
      if @course.update(teacher_course_params)
        redirect_to [:teacher, @course], notice: i18n_notice('updated', @course)
      else
        render :edit
      end
    end

    def channel
      @course.channels.destroy_all
      @course.init_channel
      @channel = @course.channels.last
    end

    private

    def courses_chain
      # current_user可能是manager
      # @teacher = current_user
      @teacher.live_studio_courses
    end

    def set_course
      @course = courses_chain.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through for update.
    def teacher_course_params
      params.require(:course).permit(:name, :description)
    end
  end
end
