require 'test_helper'

class CustomizedCourseAATest < ActiveSupport::TestCase


  test "validate customize course" do
    cc = customized_courses(:customized_course1)
    assert cc.valid?
    assert cc.teachers.size == 2
  end

end
