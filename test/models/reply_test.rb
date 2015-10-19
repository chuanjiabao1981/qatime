require 'test_helper'
require 'tally_test_helper'

class ReplyTest < ActiveSupport::TestCase
  include TallyTestHelper

  def setup
    @topic = topics(:topic1)
    @old =     APP_CONSTANT["price_per_minute"]

    APP_CONSTANT["price_per_minute"] = 1
  end

  def teardown
    APP_CONSTANT["price_per_minute"] = @old

  end
  # test "reply create" do
  #   reply             = @topic.teacher.replies.build
  #   reply.topic      = @topic
  #   reply.content    = "sbsb zsb hahaha"
  #   assert reply.valid?,reply.errors.full_messages
  # end

  test "fixture" do
    student_reply1 = replies(:student_reply1)
    teacher_reply1 = replies(:teacher_reply2)
    assert student_reply1.valid?, student_reply1.errors.full_messages
    assert teacher_reply1.valid?, teacher_reply1.errors.full_messages
  end

  # 测试reply的记账功能
  test "reply keep_account" do
    teacher = Teacher.find(users(:teacher_tally).id)
    student = Student.find(users(:student_tally).id)

    course_issue_replies = CourseIssueReply.by_author_id(teacher.id).valid_tally_unit

    keep_account_succeed(teacher, student, course_issue_replies, 5) do
      CourseIssueReply.by_author_id(teacher.id).valid_tally_unit.size
    end

    tutorial_issue_replies = TutorialIssueReply.by_author_id(teacher.id).valid_tally_unit

    keep_account_succeed(teacher, student, tutorial_issue_replies, 5) do
      tutorial_issue_replies.by_author_id(teacher.id).valid_tally_unit.size
    end
  end
end