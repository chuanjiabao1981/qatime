#require_dependency "live_studio/application_controller"

module LiveStudio
  class Teacher::LessonsController < Teacher::BaseController
    before_action :set_course
    before_action :set_lesson, only: [
      :show, :edit, :update, :destroy,
      :ready, :begin_live_studio, :end_live_studio
    ]

    # GET /teacher/lessons
    def index
      @lessons = LiveStudio::Lesson.all
    end

    # GET /teacher/lessons/1
    def show
    end

    # GET /teacher/lessons/new
    def new
      @lesson = Lesson.new
    end

    # GET /teacher/lessons/1/edit
    def edit
    end

    # POST /teacher/lessons
    def create
      @lesson = @course.lessons.new(lesson_params)
      @lesson.teacher = current_user

      if @lesson.save
        redirect_to teacher_course_path(params[:course_id]), notice: i18n_notice('created', @lesson)
      else
        render :new
      end
    end

    def ready
      @lesson.ready!
    end

    # PATCH/PUT /teacher/lessons/1
    def update
      if @lesson.update(lesson_params)
        redirect_to teacher_course_path(@course), notice: i18n_notice('updated', @lesson)
      else
        render :edit
      end
    end

    # DELETE /teacher/lessons/1
    def destroy
      @lesson.destroy
      redirect_to teacher_course_path(@course), notice: i18n_notice('destroyed', @lesson)
    end

    def begin_live_studio
      @lesson.touch(:live_start_at)
      @lesson.teaching!
      redirect_to teacher_course_path(params[:course_id]), notice: i18n_notice('begin_live_studio', @lesson)
    end

    def end_live_studio
      @lesson.update(live_count: @lesson.play_records.count)
      @lesson.touch(:live_end_at)
      @lesson.finish

      redirect_to teacher_course_path(params[:course_id]), notice: i18n_notice('end_live_studio', @lesson)
    end

    private

    def set_lesson
      @lesson = Lesson.find_by(id: params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lesson_params
      params.require(:lesson).permit(:name, :description, :start_time, :end_time, :class_date)
    end
  end
end
