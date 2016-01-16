require_dependency "course_library/application_controller"

module CourseLibrary
  class SyllabusesController < ApplicationController

    def index
      @syllabuses = Syllabus.all.order(:created_at)
    end

    def new
      @syllabus = Syllabus.new
    end

    def create
      @syllabus = Syllabus.new(params[:syllabus].permit!)
      if @syllabus.save
        redirect_to syllabuses_path
      else
        render 'new'
      end
    end

    def show
      @syllabus = Syllabus.find(params[:id])
    end

    def edit
      @syllabus = Syllabus.find(params[:id])
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
