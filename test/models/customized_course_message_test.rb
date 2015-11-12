require 'test_helper'

class CustomizedCourseMessageTest < ActiveSupport::TestCase
  test "customize course message" do
    customized_course_message_board = customized_course_message_boards(:customized_course_message_board)
    teacher                         = users(:teacher1)
    assert customized_course_message_board.valid?
    customized_course_message       =
        customized_course_message_board.customized_course_messages.build(title: "12342",content: "1234",author: teacher)
    assert customized_course_message.valid?,customized_course_message.errors.full_messages
    assert_not customized_course_message.customized_course.nil?
    assert_not customized_course_message.token.nil?
    assert_difference 'CustomizedCourseMessage.count',1 do
      assert_difference 'customized_course_message_board.reload.customized_course_messages_count',1 do
        assert_difference 'CustomizedCourseActionRecord.count',1 do
          assert_difference 'CustomizedCourseActionNotification.count',2 do
            customized_course_message.save
          end
        end
      end
    end
  end
end
