module CustomizedCoursesHelper

  def customized_course_full_name(customized_course)
    customized_course.name
  end

  def xeditable? object = nil
    true # Or something like current_user.xeditable?
  end
end