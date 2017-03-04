require 'test_helper'
require 'models/shared/qa_common_state_test'
require 'models/shared/utils/qa_test_factory'
require 'models/shared/qa_issue_test'

class TutorialIssueTest < ActiveSupport::TestCase
  self.use_transactional_tests = true

  include QaCommonStateTest
  include QaIssueTest
  test "tutorial issue create" do
    customized_tutorial       = customized_tutorials(:customized_tutorial1)
    tutorial_issue            = customized_tutorial.tutorial_issues.build(
        title: "title aSDFASDFA",
        content:"content IKMUJNYHFG",
        last_operator: customized_tutorial.teacher
    )
    tutorial_issue.author     = customized_tutorial.teacher
    assert_not tutorial_issue.token.nil?
    assert tutorial_issue.customized_course.valid?
    assert tutorial_issue.valid?,tutorial_issue.errors.full_messages
    assert_difference 'TutorialIssue.count',1 do
      assert_difference 'CustomizedCourseActionRecord.count',1 do
        assert_difference 'CustomizedCourseActionNotification.count',2 do
          tutorial_issue.save!
        end
      end
    end
  end

  test "tutorial issue state change" do

    tutorial_issue_for_state_change = topics(:tutorial_issue_for_state_change)
    check_issue_state_change_process(tutorial_issue_for_state_change)

  end

  test "tutorial issue state cant complete" do
    tutorial_issue_for_state_change = topics(:tutorial_issue_for_state_change)
    check_cant_complete tutorial_issue_for_state_change
  end


end
