require 'models/shared/utils/qa_test_factory'
require 'models/shared/qa_common_state_test'

module QaIssueTest
  include QaCommonStateTest
  def check_issue_state_change_process(issue)

    assert issue.valid?
    check_first_handle_timestamp issue do
      QaTestFactory::QaIssueReplyFactory.create(issue)
    end

    check_complete_timestamp issue

    assert_not issue.can_handle?
    check_redo_timestamp issue

    check_handle_timestamp issue do
      QaTestFactory::QaIssueReplyFactory.create(issue)
    end
  end


  #examination没有solution的情况
  def check_cant_complete_1(examination)
    assert examination.solutions.length == 0
    examination.state_event     = :complete
    assert_not examination.valid?
    assert examination.errors.added? :base,:cant_complete_solutions_zero
  end

  #examination有solution，但是状态不是complete
  def check_cant_complete_2(examination)
    assert examination.solutions.length == 0
    QaTestFactory::QaSolutionFactory.create examination,completed: false
    examination.reload
    examination.state_event     = :complete
    assert_not examination.valid?
    assert examination.errors.added? :base,:cant_complete_solutions_not_complete
  end
end