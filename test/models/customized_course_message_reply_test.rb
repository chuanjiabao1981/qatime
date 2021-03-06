require 'test_helper'

class MessageReplyTest < ActiveSupport::TestCase
  test "customized course message reply creat" do
    customized_course_message       = customized_course_messages(:customized_course_message1)
    student                         = users(:student1)
    assert customized_course_message.valid?
    customized_course_message_reply  =
        customized_course_message.customized_course_message_replies.build(content: "sdafs",
                                                                          author: student,
                                                                          last_operator: student
        )
    assert customized_course_message_reply.valid?
    assert_not customized_course_message_reply.token.nil?
    assert_not customized_course_message_reply.customized_course.nil?
    assert_difference 'CustomizedCourseMessageReply.count',1 do
      assert_difference 'customized_course_message.reload.customized_course_message_replies.count',1 do
        assert_difference 'customized_course_message.customized_course_message_board.reload.customized_course_message_replies_count',1 do
          assert_difference 'CustomizedCourseActionRecord.count',1 do
            assert_difference 'CustomizedCourseActionNotification.count',2 do
              customized_course_message_reply.save
            end
          end
        end
      end
    end
  end
end
