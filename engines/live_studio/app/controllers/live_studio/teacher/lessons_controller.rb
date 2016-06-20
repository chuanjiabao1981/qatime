require_dependency "live_studio/application_controller"

module LiveStudio
  class Teacher::LessonsController < ApplicationController
    before_action :set_course
    before_action :set_teacher_lesson, only: [:show, :edit, :update, :destroy]

    # GET /teacher/lessons
    def index
      @teacher_lessons = Teacher::Lesson.all
    end

    # GET /teacher/lessons/1
    def show
    end

    # GET /teacher/lessons/new
    def new
      @teacher_lesson = Teacher::Lesson.new
    end

    # GET /teacher/lessons/1/edit
    def edit
    end

    # POST /teacher/lessons
    def create
      @teacher_lesson = Teacher::Lesson.new(teacher_lesson_params)

      if @teacher_lesson.save
        redirect_to @teacher_lesson, notice: 'Lesson was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /teacher/lessons/1
    def update
      if @teacher_lesson.update(teacher_lesson_params)
        redirect_to @teacher_lesson, notice: 'Lesson was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /teacher/lessons/1
    def destroy
      @teacher_lesson.destroy
      redirect_to teacher_lessons_url, notice: 'Lesson was successfully destroyed.'
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
