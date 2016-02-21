module CourseLibrary
  module CoursePublicationsHelper
    def available_customized_course_for_publish(course_publication)
      if course_publication.new_record?
        course = course_publication.course
      else
        return [course_publication.customized_course]
      end
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
