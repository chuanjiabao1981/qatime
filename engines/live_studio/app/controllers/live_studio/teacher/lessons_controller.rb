#require_dependency "live_studio/application_controller"

module LiveStudio
  class Teacher::LessonsController < Teacher::BaseController
    before_action :set_course
    before_action :set_teacher_lesson, only: [:show, :edit, :update, :destroy]

    # GET /teacher/lessons
    def index
      @teacher_lessons = LiveStudio::Lesson.all
    end

    # GET /teacher/lessons/1
    def show
    end

    # GET /teacher/lessons/new
    def new
      @teacher_lesson = Lesson.new
    end

    # GET /teacher/lessons/1/edit
    def edit
    end

    # POST /teacher/lessons
    def create
      @teacher_lesson = LiveStudio::Lesson.new(teacher_lesson_params)

      if @teacher_lesson.save
        redirect_to teacher_course_path(params[:course_id]), notice: i18n_notice('created', @teacher_lesson)
      else
        render :new
      end
    end

    # PATCH/PUT /teacher/lessons/1
    def update
      if @teacher_lesson.update(teacher_lesson_params)
        redirect_to teacher_course_path(params[:course_id]), notice: i18n_notice('updated', @teacher_lesson)
      else
        render :edit
      end
    end

    # DELETE /teacher/lessons/1
    def destroy
      @teacher_lesson.destroy
      redirect_to teacher_course_path(params[:course_id]), notice: i18n_notice('destroyed', @teacher_lesson)
    end


    private

    def set_teacher_lesson
      @teacher_lesson = Lesson.find_by(id: params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def teacher_lesson_params
      params.require(:lesson).permit(:name, :description, :start_time, :end_time, :class_date).merge(course_id: params[:course_id])
    end
  end
end
