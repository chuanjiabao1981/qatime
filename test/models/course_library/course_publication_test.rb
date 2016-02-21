require 'test_helper'

module CourseLibrary
  class CoursePublicationTest < ActiveSupport::TestCase


    test "validate" do
      course_publication = course_library_course_publications(:course_publication_for_course_one)
      assert course_publication.valid?
    end

    test "uniquenes" do
      course             = course_library_courses(:course_one)
      customized_course  = customized_courses(:customized_course_for_course_library)
      course_publication = CoursePublication.new(course: course,customized_course: customized_course)

      #有已经有了所以not valid
      assert_not course_publication.valid?


      course            = course_library_courses(:course_for_tally)
      course_publication = CoursePublication.new(course: course,customized_course: customized_course)


      #没有所以valid

      assert course_publication.valid?

    end

  end
end
