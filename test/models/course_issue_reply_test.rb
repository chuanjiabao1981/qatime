require 'test_helper'
require 'tally_test_helper'

class CourseIssueReplyModelTest < ActiveSupport::TestCase
  include TallyTestHelper

  def setup

  end

  def teardown

  end

  test "course issue reply create" do
    course_issue_one = topics(:course_issue_one)
    assert course_issue_one.valid?,course_issue_one.errors.full_messages
    teacher            = users(:teacher1)
    assert_difference "course_issue_one.reload.replies_count",1 do
      course_reply     = course_issue_one.course_issue_replies.build({content: "xxxxxxx",author: teacher})
      customized_course_prices_validation(course_reply) do
        course_reply.content = "yyyyyyyyyyyyyyyy"
      end

      assert      course_reply.valid?
      assert_not  course_reply.token.nil?
      assert      course_reply.course_issue.id == course_issue_one.id
    end
  end

end