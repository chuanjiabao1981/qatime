#require_dependency "live_studio/application_controller"

module LiveStudio
  class Teacher::LessonsController < Teacher::BaseController
    before_action :set_course
    before_action :set_lesson, only: [
      :show, :edit, :update, :destroy,
      :ready, :begin_live_studio, :end_live_studio, :complete
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
      LiveService::LessonDirector.edit_lessons(@course, params)
      @course.update(lesson_count: @course.lessons.count)
      redirect_to teacher_course_path(@teacher,params[:course_id],index: 'list'),
                  notice: t("activerecord.successful.messages.updated", model: LiveStudio::Lesson.model_name.human)
    end

    def ready
      @lesson.ready!
      redirect_to teacher_course_path(@teacher,params[:course_id])
    end

    # PATCH/PUT /teacher/lessons/1
    def update
      if @lesson.update(lesson_params)
        redirect_to teacher_course_path(@teacher,@course), notice: i18n_notice('updated', @lesson)
      else
        render :edit
      end
    end

    # DELETE /teacher/lessons/1
    def destroy
      @lesson.destroy
      redirect_to edit_teacher_course_path(@teacher,@course,index: 'list'), notice: i18n_notice('destroyed', @lesson)
    end

    def begin_live_studio
      LiveService::LessonDirector.new(@lesson).lesson_start
      redirect_to teacher_course_path(@teacher,params[:course_id]), notice: i18n_notice('begin_live_studio', @lesson)
    end

    def end_live_studio
      @lesson.close!
      redirect_to teacher_course_path(@teacher,params[:course_id]), notice: i18n_notice('end_live_studio', @lesson)
    end

    # 结算失败的课程单独结算
    def complete
      @course = @lesson.course
      # 课程结算
      BusinessService::CourseBillingDirector.new(@lesson).billing_lesson
      redirect_to teacher_course_path(@teacher, @course), notice: i18n_notice('end_live_studio', @lesson)
    end

    private

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
