require_dependency "course_library/application_controller"

module CourseLibrary
  class CoursesController < ApplicationController
    def new
      @course = @directory.courses.build
    end

    def edit
    end
    def index
      puts "this is a test message"
      @courses = Course.get_all_courses(current_resource)
    end
    def create
      @course = @directory.courses.build(params[:course].permit!)
      respond_with @directory.syllabus, @directory, @course
    end
  end
end
