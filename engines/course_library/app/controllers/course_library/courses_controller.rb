require_dependency "course_library/application_controller"

module CourseLibrary
  class CoursesController < ApplicationController
    respond_to :html
    def new
      @syllabus = Syllabus.find(params[:syllabus_id])
      @directory = Directory.find(params[:directory_id])
      @course = @directory.courses.build()
    end

    def edit
      @course = Course.find(params[:id])
      @directory = @course.directory
      @syllabus = @directory.syllabus
    end

    def index
      @courses = Course.get_all_courses(current_resource)
    end
    def create
      @syllabus = Syllabus.find(params[:syllabus_id])
      @directory = Directory.find(params[:directory_id])
      @course = @directory.courses.build(params[:course].permit!)
      if @course.save
        flash[:success] = "创建成功"
      end
      respond_with @syllabus, @directory, @course
      #respond_with @course
    end

    def update
      @course = Course.find(params[:id])
      @directory = @course.directory
      @syllabus = @directory.syllabus
      if @course.update(params[:course].permit!)
        flash[:success] = "更新成功"
      end
      respond_with @syllabus, @directory, @course
    end

    def show
      @course = Course.find(params[:id])
      @directory = @course.directory
      @syllabus = @directory.syllabus
    end
  end
end
