require_dependency "live_studio/teacher/base_controller"

module LiveStudio
  class Teacher::CoursesController < Teacher::BaseController
    layout 'teacher_home_new'

    before_action :set_course, only: [:show, :edit, :update, :destroy, :channel, :close, :update_class_date]

    def index
      @courses = LiveService::CourseDirector.courses_for_teacher_index(@teacher, params).paginate(page: params[:page])
    end

    def show
      @lessons = @course.lessons.order("id").paginate(page: params[:page])
    end

    def edit
      @lessons = @course.lessons.order("id").paginate(page: params[:page])
    end

    # PATCH/PUT /teachers/:teacher_id/courses/:id
    def update
      if @course.update(teacher_course_params)
        redirect_to teacher_course_path(@teacher, @course), notice: i18n_notice('updated', @course)
      else
        render :edit
      end
    end

    def channel
      @course.channels.destroy_all
      @course.init_channel
      @channel = @course.channels.last
    end

    def close
      @course.completed! if @course.ready_for_close?
      redirect_to teacher_course_path(@teacher, @course), notice: i18n_notice('closed', @course)
    end

    def update_class_date
      @lessons = @course.lessons.order("id").paginate(page: params[:page])
    end

    private

    def courses_chain
      @teacher.live_studio_courses
    end

    def set_course
      @course = courses_chain.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through for update.
    def teacher_course_params
      params.require(:course).permit(:name, :preset_lesson_count,:description,:publicize, :price)
    end

  end
end
