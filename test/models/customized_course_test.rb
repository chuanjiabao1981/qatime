require 'test_helper'

class CustomizedCourseAATest < ActiveSupport::TestCase


  test "validate customize course" do
    cc = customized_courses(:customized_course1)
    assert cc.valid?
    assert cc.teachers.size == 2 , cc.teachers.size

  end

  test "timeout_to_solve_home" do
    cc = customized_courses(:customized_course3)
    assert cc.valid?
    assert cc.homeworks.first.valid?
    assert cc.timeout_to_solve_homeworks.count == 1

  end

end
