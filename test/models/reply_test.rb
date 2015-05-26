require 'test_helper'

class ReplyTest < ActiveSupport::TestCase

  def setup
    @topic = topics(:topic1)
  end
  test "reply create" do
    reply         = @topic.teacher.replies.build
    reply.topic   = @topic
    reply.body    = "sbsb zsb hahaha"
    assert reply.valid?,reply.errors.full_messages
  end
end