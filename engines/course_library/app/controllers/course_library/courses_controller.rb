require_dependency "course_library/application_controller"

module CourseLibrary
  class CoursesController < ApplicationController
    def new
      @course = @directory.courses.build
    end

    def edit
    end

    def create
      @course = @directory.courses.build(params[:course].permit!)

      if @course.save
        flash[:success] = "成功创建 " + @course.title
      end
      respond_with @directory.syllabus, @directory, @course
    end
  end
end
