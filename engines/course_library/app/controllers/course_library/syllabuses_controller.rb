require_dependency "course_library/application_controller"

module CourseLibrary
  class SyllabusesController < ApplicationController

    def index
      @teacher = Teacher.find(params[:teacher_id])
      @syllabuses = @teacher.syllabuses.order(:title)
      render layout: 'teacher_home_new'
    end

    def new
      @teacher = Teacher.find(params[:teacher_id])
      @syllabus = @teacher.syllabuses.build
      render layout: 'teacher_home_new'
    end

    def create
      @teacher = Teacher.find(params[:teacher_id])
      @syllabus = @teacher.syllabuses.create(params[:syllabus].permit!)
      if @syllabus.save
        redirect_to teacher_syllabuses_path(@teacher)
      else
        render 'new',layout: 'teacher_home_new'
      end
    end

    def edit
      @syllabus = Syllabus.find(params[:id])
      @teacher = @syllabus.author
      render layout: 'teacher_home_new'
    end

    def update
      @syllabus = Syllabus.find(params[:id])
      @teacher = @syllabus.author
      if @syllabus.update_attributes(params[:syllabus].permit!)
        redirect_to teacher_syllabuses_path(@teacher)
      else
        render 'edit',layout: 'teacher_home_new'
      end
    end

    def destroy
      @syllabus = Syllabus.find(params[:id])
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

  end
end
