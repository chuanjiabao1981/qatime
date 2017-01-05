require 'test_helper'

module LiveServiceTest
  class CourseDirectorTest < ActiveSupport::TestCase
    # 试听测试
    test 'taste course' do
      course = live_studio_courses(:course_with_lessons)
      student = users(:student_with_order2)
      assert_difference "LiveStudio::TasteTicket.count", 1, "试听失败" do
        LiveService::CourseDirector.taste_course_ticket(student, course)
      end
    end

    # 不可以试听测试
    test "taste zero course" do
      course = live_studio_courses(:course_zero_taste)
      student = users(:student_with_order2)
      assert_difference "LiveStudio::TasteTicket.count", 0, "不可以试听的辅导班试听成功" do
        LiveService::CourseDirector.taste_course_ticket(student, course)
      end
    end
  end
end
