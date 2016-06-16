require 'test_helper'

module LiveStudio
  class CourseTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end

    test "course must has a teacher name or blank" do
      teacher = Teacher.find(users(:teacher1).id)
      course = live_studio_courses(:course_one)
      course.teacher = teacher
      assert_equal(teacher.name, course.teacher_name, "教师姓名不相符")

      course_no_teacher = live_studio_courses(:course_no_teacher)
      assert_nil(course_no_teacher.teacher_name, "教师姓名不为空")

      course_destroy_teacher = live_studio_courses(:course_destroy_teacher)
      assert_nil(course_destroy_teacher.teacher_name, "教师姓名不为空")
    end

    test "get order parmas" do
      course = live_studio_courses(:course_one)
      assert_equal([:total_money, :product], course.order_params.keys, "订单参数格式不对")
      assert_equal(course.price, course.order_params[:total_money], "订单金额不正确")
      assert_equal(course, course.order_params[:product], "购买错误商品")
    end

    test "initialize channel for course" do
      course = live_studio_courses(:course_without_channel)
      assert_difference('course.channels.count', 1, "channel 初始化失败") do
        course.init_channel
      end

      assert_no_difference('course.channels.count', "channel 重复初始化") do
        course.init_channel
      end
    end
  end
end
