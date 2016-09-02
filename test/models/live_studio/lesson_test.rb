require 'test_helper'

module LiveStudio
  class LessonTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end

    test "order lessons" do
      course = live_studio_courses(:update_course_by_physics_teacher1)
      order_lessons = course.order_lessons

      assert live_studio_lessons(:lesson3_of_update_course), order_lessons.first
    end
  end
end
