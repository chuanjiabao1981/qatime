require 'test_helper'

class CustomizedCourseMessageRepliesControllerTest < ActionController::TestCase
  def setup
    @customized_course_message        = customized_course_messages(:customized_course_message1)
    @customized_course_message_reply  = customized_course_message_replies(:customized_course_message_reply1)
    assert @customized_course_message_reply.valid?
  end

  # test "create message" do
  #   media_id = Wechat.api.media_create("voice", "#{Rails.root}/engines/qawechat/test/fixtures/qawechat/voice.amr")['media_id']
  #   user = users(:student1)
  #   log_in_as(user)
  #   post :create, params:{media_id: media_id}
  #   debugger
  # end
end
