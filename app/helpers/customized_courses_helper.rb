module CustomizedCoursesHelper

  def customized_course_full_name(customized_course)
    "#{CustomizedCourse.model_name.human}-#{customized_course.created_at.strftime("%Y-%m-%d")}"
  end
end