require 'test_helper'

class TutorialIssueReplyModelTest < ActiveSupport::TestCase

  def setup

  end

  def teardown

  end



  test "tutorial issue reply create" do
    tutorial_issue_one = topics(:tutorial_issue_one)
    assert tutorial_issue_one.valid?,tutorial_issue_one.errors.full_messages
    teacher            = users(:teacher1)
    assert_difference "tutorial_issue_one.reload.replies_count",1 do
      assert_difference "CustomizedCourseActionRecord.count",1 do
        tutorial_reply     = tutorial_issue_one.tutorial_issue_replies.build({content: "xxxxxxx",author: teacher})
        tutorial_reply.save!
        assert      tutorial_reply.valid?
        assert_not  tutorial_reply.token.nil?
        assert      tutorial_reply.tutorial_issue.id == tutorial_issue_one.id
      end
    end
  end

end