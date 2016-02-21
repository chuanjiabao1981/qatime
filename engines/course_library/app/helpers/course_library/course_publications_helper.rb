module CourseLibrary
  module CoursePublicationsHelper
    def available_customized_course_for_publish(course)
      teacher =  course.author
      a = teacher.customized_courses
      b = []
      course.course_publications.each do |cp|
        b << cp.customized_course
      end
      a - b
    end
  end
end
