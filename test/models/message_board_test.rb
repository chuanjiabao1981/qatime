require 'test_helper'

class MessageBoardTest < ActiveSupport::TestCase
  test "custommized course message board create" do
    @customized_course                = customized_courses(:customized_course1)
    @customized_course_message_board  = @customized_course.build_customized_course_message_board
    assert   @customized_course_message_board.valid?
    assert   @customized_course_message_board.messageboardable == @customized_course
  end
end
