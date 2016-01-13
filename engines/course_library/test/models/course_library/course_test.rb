require 'test_helper'

module CourseLibrary
  class CourseTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
    test "create a course" do
      course=Course.new
      course.title="1"
      course.description="2"
      assert course.valid?
    end
  end
end
