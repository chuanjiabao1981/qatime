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

  # 测试记账功能
  test "reply keep_account" do
    #
    teacher = Teacher.find(users(:teacher1).id)
    assert Reply.by_teacher(teacher.id).valid_tally_unit.size == 3

    reply = replies(:reply_with_video_1)

    video = videos(:reply_video_1)
    assert reply.token == video.token
    assert reply.valid?,reply.errors.full_messages
    assert video.valid?,video.errors.full_messages

    assert_not_nil video
    assert reply.video == video

    reply.keep_account(teacher.id)
    reply_1 = replies(:reply_with_video_2)
    reply_1.keep_account(teacher.id)

    # 帐号发生了变化
    # 生成了fee
    student = Student.find(users(:student1).id)
    assert teacher.account.money == 2.7
    assert student.account.money == -2.7

    fee = reply_1.fee
    assert_not_nil fee
    assert fee.value == 1.7
    assert fee.feeable_id = reply_1.id
    assert fee.feeable_type = "Reply"
    assert fee.customized_course_id = reply_1.customized_course_id

    fee = reply.fee
    assert_not_nil fee
    assert fee.value == 1
    assert fee.feeable_id = reply.id
    assert fee.feeable_type = "Reply"
    assert fee.customized_course_id = reply.customized_course_id

    assert reply.status == "closed"
    assert reply_1.status == "closed"
    assert Reply.by_teacher(teacher.id).valid_tally_unit.size == 1
  end

end