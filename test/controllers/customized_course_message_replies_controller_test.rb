require 'test_helper'

class CustomizedCourseMessageRepliesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @customized_course_message        = customized_course_messages(:customized_course_message1)
    @customized_course_message_reply  = customized_course_message_replies(:customized_course_message_reply1)
    assert @customized_course_message_reply.valid?
    @user = users(:student_tally)
  end
end
