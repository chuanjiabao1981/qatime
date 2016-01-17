require 'test_helper'

module CourseLibrary
  class PublicationTest < ActiveSupport::TestCase
    test "publication create test" do
      a = course_library_courses(:one)
      b = customized_courses(:one)
      assert_difference 'Publication.count',1 do
        assert a.valid?,a.errors.full_messages
        a.customized_courses << b
      end
    end
  end
end
