require 'test_helper'

class TutorialIssueTest < ActiveSupport::TestCase
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


end
