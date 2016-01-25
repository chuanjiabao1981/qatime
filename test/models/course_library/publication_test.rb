require 'test_helper'

module CourseLibrary
  class PublicationTest < ActiveSupport::TestCase
    test "customized tutorial create test" do
      syllabuses_one = course_library_syllabuses(:syllabuses_one)
      directory_one  = course_library_directories(:directory_one)
      course_one     = course_library_courses(:course_one)
      assert syllabuses_one.valid?
      assert course_one.valid?
      assert directory_one.valid?
      publication    = course_one.publications.build()
    end
  end
end
