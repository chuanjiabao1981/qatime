require 'test_helper'

module LiveStudio
  class CourseTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end

    test "course must has a teacher name or blank" do
      course = courses(:course_one)
      teacher = teachers(:teacher_one)
      assert_equal(course.teacher_name, teacher.name, "教师姓名不相符")

      course_no_teacher = courses(:course_no_teacher)
      assert_empty(course_no_teacher.teacher_name, "教师姓名不为空")

      course_destroy_teacher = courses(:course_destroy_teacher)
      assert_empty(course_destroy_teacher.teacher_name, "教师姓名不为空")
    end
  end
end
