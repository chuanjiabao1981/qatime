require 'test_helper'
require 'tally_test_helper'
require 'models/shared/utils/qa_test_factory'

class TutorialIssueReplyModelTest < ActiveSupport::TestCase
  include TallyTestHelper
  include QaTestFactory::QaIssueReplyFactory

  def setup

  end

  def teardown

  end

  test "tutorial issue reply create" do
    tutorial_issue_one = topics(:tutorial_issue_one)
    assert tutorial_issue_one.valid?,tutorial_issue_one.errors.full_messages
    assert_difference "tutorial_issue_one.reload.replies_count",1 do
      assert_difference "CustomizedCourseActionRecord.count",1 do
        assert_difference "CustomizedCourseActionNotification.count",2 do
          tutorial_reply     = QaTestFactory::QaIssueReplyFactory.build(tutorial_issue_one)
          tutorial_reply.save!
          assert      tutorial_reply.valid?
          assert_not  tutorial_reply.token.nil?
          assert      tutorial_reply.tutorial_issue.id == tutorial_issue_one.id
        end
      end
    end
  end

end
