require_dependency "course_library/application_controller"

module CourseLibrary
  class CoursesController < ApplicationController
    def available_customized_courses_for_publish
      @teacher                      = @course.author
      @available_customized_courses = @course.available_customized_course_for_publish
    end

    def publish

    end

    def current_resource
      @course = Course.find(params[:id])
    end
  end
end
