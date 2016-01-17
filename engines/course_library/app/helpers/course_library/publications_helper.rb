module CourseLibrary
  module PublicationsHelper
    def available_customized_courses(course,teacher)
      teacher.customized_courses - course.customized_courses
    end
  end
end
