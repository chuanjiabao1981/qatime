require_dependency "course_library/application_controller"

module CourseLibrary
  class SyllabusesController < ApplicationController
    before_action :set_owner

    layout 'v1/home'

    def index
      @syllabuses = @teacher.syllabuses.order(:title).paginate(page: params[:page])
    end

    def new
      @syllabus = @teacher.syllabuses.build
    end

    def create
      @teacher = Teacher.find(params[:teacher_id])
      @syllabus = @teacher.syllabuses.create(params[:syllabus].permit!)
      if @syllabus.save
        redirect_to teacher_syllabuses_path(@teacher)
      else
        render :new
      end
    end

    def edit
      @teacher = @syllabus.author
    end

    def update
      @syllabus = Syllabus.find(params[:id])
      @teacher = @syllabus.author
      if @syllabus.update_attributes(params[:syllabus].permit!)
        redirect_to teacher_syllabuses_path(@teacher)
      else
        render :edit
      end
    end

    def destroy
      @teacher = @syllabus.author
      @syllabus.destroy
      redirect_to teacher_syllabuses_path(@teacher)
    end

    private
    def current_resource
      if ! params[:id].nil?
        @syllabus = Syllabus.find(params[:id])
      else
        @teacher = Teacher.find(params[:teacher_id])
      end
    end

    def set_owner
      @teacher ||= Teacher.find_by(id: params[:teacher_id])
      @owner = @teacher
    end

  end
end
