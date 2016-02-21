require_dependency "course_library/application_controller"

module CourseLibrary
  class CoursesController < ApplicationController
    include QaFilesHelper
    respond_to :html
    def new
      @directory = Directory.find(params[:directory_id])
      @syllabus = @directory.syllabus
      @course = @directory.courses.build()
      @video = Video.new()
    end

    def edit
      @course = Course.find(params[:id])
      @directory = @course.directory
      @syllabus = @directory.syllabus
      @video = Video.new()
    end

    def index
      @directory = Directory.find(params[:directory_id])
      @courses = @directory.courses
    end
    def create
      @directory = Directory.find(params[:directory_id])
      @syllabus = @directory.syllabus
      @course = @directory.courses.build(change_params_for_qa_files(params[:course].permit!))
      if @course.save
        flash[:success] = "创建成功"
      end
      respond_with  @directory, @course
      #respond_with @course
    end

    def update
      @course = Course.find(params[:id])
      @directory = @course.directory
      @syllabus = @directory.syllabus
      if @course.update(change_params_for_qa_files(params[:course].permit!))
        flash[:success] = "更新成功"
      end
      respond_with @directory, @course
    end

    def destroy
      @course = Course.find(params[:id])
      @directory = @course.directory
      @syllabus = @directory.syllabus
      @course.destory
      redirect_to syllabus_directory_path(@syllabus, @directory)
    end

    def show
      @course = Course.find(params[:id])
      @directory = @course.directory
      @syllabus = @directory.syllabus
      # @customized_tutorials = @course.customized_tutorials
    end

    def mark_delete
      @course.directory = nil
      if @course.save
        flash[:success] = "删除成功"
      end
      respond_with @directory
    end

private
    def current_resource
      if params[:id]
        @course = Course.find(params[:id])
        @directory = @course.directory
        @syllabus = @directory.syllabus
        @teacher = @syllabus.author
        @course
      else
        @directory = Directory.find(params[:directory_id])
        @syllabus = @directory.syllabus
        @teacher = @syllabus.author
        @directory
      end
    end
  end
end
