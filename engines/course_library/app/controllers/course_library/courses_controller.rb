require_dependency "course_library/application_controller"

module CourseLibrary
  class CoursesController < ApplicationController
    def available_customized_courses_for_publish
      @available_customized_courses = @course.available_customized_course_for_publish
    end

    def customized_tutorials
      @customized_tutorials = @course.customized_tutorials
    end
    def publish
      params[:course][:available_customized_course_ids].delete("")
      @course.update_attributes(params[:course].permit!)
      redirect_to customized_tutorials_course_path(@course)
    end

    def un_publish
      if @course.un_publish(params[:customized_tutorial_id])
        flash[:success] = t("view.course_library/course.un_publish_success")
      else
        flas[:error]    = t("view.course_library/course.un_publish_fail")
      end
      redirect_to customized_tutorials_course_path(@course)
    end
    def current_resource
      @course = Course.find(params[:id])
      @teacher                      = @course.author
      @course
    end
  end
end
