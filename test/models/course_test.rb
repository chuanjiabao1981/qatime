require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  test "the truth" do
    course1 = courses(:teacher1_course)
    assert course1.valid?

  end
end
