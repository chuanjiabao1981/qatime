require 'test_helper'

class ReplyTest < ActiveSupport::TestCase

  def setup
    @topic = topics(:topic1)
  end
  test "reply create" do
    reply             = @topic.teacher.replies.build
    reply.topic      = @topic
    reply.content    = "sbsb zsb hahaha"
    assert reply.valid?,reply.errors.full_messages
  end

  test "fixture" do
    student_reply1 = replies(:student_reply1)
    teacher_reply1 = replies(:teacher_reply2)
    assert student_reply1.valid?, student_reply1.errors.full_messages
    assert teacher_reply1.valid?, teacher_reply1.errors.full_messages
  end
end