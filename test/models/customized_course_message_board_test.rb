require 'test_helper'

class CustomizedCourseMessageBoardTest < ActiveSupport::TestCase
  test "custommized course message board create" do
    @customized_course                = customized_courses(:customized_course1)
    @customized_course_message_board  = @customized_course.build_customized_course_message_board
    assert   @customized_course_message_board.valid?
  end
end
