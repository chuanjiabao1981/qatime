require_dependency "live_studio/teacher/base_controller"

module LiveStudio
  class Teacher::CoursesController < Teacher::BaseController
    layout 'v1/home'

    before_action :set_course, only: [:show, :edit, :update, :destroy, :channel, :close, :update_class_date, :desrtoy, :update_lessons]

    def index
      @courses = @teacher.live_studio_courses
      @courses = @courses.where(course_search_params) if course_search_params.present?
      @courses = @courses.order(id: :desc).paginate(page: params[:page])
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
    end

    def destroy
      if @course.init? || @course.rejected?
        @course.destroy
        redirect_to live_studio.teacher_courses_path(@teacher), notice: 'delete successfully'
      else
        redirect_to live_studio.teacher_courses_path(@teacher), alert: 'delete failed'
      end
    end

    def update_lessons
      if @course.update(lessons_params)
        @course.ready_lessons
        redirect_to live_studio.teacher_courses_path(@teacher), notice: i18n_notice('updated', @course)
      else
        render :update_class_date
      end
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
      params.require(:course).permit(:name,:description,:publicize, :price)
    end

    def course_search_params
      course_search_status =
        case params[:cate]
        when 'waiting'
          [LiveStudio::Course.statuses[:init], LiveStudio::Course.statuses[:rejected]]
        when 'teaching'
          [LiveStudio::Course.statuses[:published], LiveStudio::Course.statuses[:teaching]]
        when 'finished'
          LiveStudio::Course.statuses[:completed]
        end
      { status: course_search_status }.compact
    end

    def lessons_params
      params.require(:course).permit(lessons_attributes: [:id, :duration, :class_date, :start_time_hour, :start_time_minute, :_update])
    end
  end
end
