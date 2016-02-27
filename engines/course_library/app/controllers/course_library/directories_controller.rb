require_dependency "course_library/application_controller"

module CourseLibrary
  class DirectoriesController < ApplicationController
    respond_to :html

    def new
      @syllabus = Syllabus.find(params[:syllabus_id])
      @directory = Directory.new
      @directory.parent = Directory.find(params[:p])
    end

    def show
      @directory = Directory.find(params[:id])
      @syllabus = @directory.syllabus
      @children = @directory.children
    end

    def create
      @syllabus = Syllabus.find(params[:syllabus_id])
      @directory = @syllabus.directories.create(params[:directory].permit!)
      if @directory.save
        redirect_to syllabus_directory_path(@syllabus,@directory.parent_id)
      else
        render 'new'
      end
    end

    def edit
      @directory = Directory.find(params[:id])
      @syllabus = @directory.syllabus
    end

    def update
      @directory = Directory.find(params[:id])
      @syllabus = @directory.syllabus
      if @directory.update_attributes(params[:directory].permit!)
        redirect_to syllabus_directory_path(@syllabus,@directory.parent_id)
      else
        render 'edit'
      end
    end

    def destroy
      @directory = Directory.find(params[:id])
      @directory.destroy
      redirect_to syllabus_directory_path(@directory.syllabus,@directory.parent)
    end
    def move_higher
      @directory.move_higher
      respond_with @directory.parent
    end
    def move_lower
      @directory.move_lower
      respond_with @directory.parent
    end
    private
    def current_resource
      if ! params[:id].nil?
        @directory = Directory.find(params[:id])
      else
        @syllabus = Syllabus.find(params[:syllabus_id])
      end
    end

  end
end
