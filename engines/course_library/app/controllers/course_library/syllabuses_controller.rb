require_dependency "course_library/application_controller"

module CourseLibrary
  class SyllabusesController < ApplicationController

    def index
      @teacher = Teacher.find(params[:teacher_id])
      @syllabuses = @teacher.syllabuses
      render layout: 'teacher_home'
    end

    def new
      @teacher = Teacher.find(params[:teacher_id])
      @syllabus = @teacher.syllabuses.build
      render layout: 'teacher_home'
    end

    def create
      @teacher = Teacher.find(params[:teacher_id])
      @syllabus = @teacher.syllabuses.create(params[:syllabus].permit!)
      if @syllabus.save
        redirect_to syllabuses_path
      else
        render 'new'
      end
    end

    def edit
      @syllabus = Syllabus.find(params[:id])
      render layout: 'teacher_home'
    end

    def update
      @syllabus = Syllabus.find(params[:id])
      if @syllabus.update_attributes(params[:syllabus].permit!)
        redirect_to syllabuses_path
      else
        render 'edit'
      end
    end

    def destroy
      @syllabus = Syllabus.find(params[:id])
      @syllabus.destroy
      redirect_to syllabuses_path
    end

  end
end
