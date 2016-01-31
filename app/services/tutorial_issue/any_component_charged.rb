class TutorialIssue::AnyComponentCharged
  def initialize(tutorial_issue)
    @tutorial_issue = tutorial_issue
  end

  def judge?
    @tutorial_issue.tutorial_issue_replies.each do |tir|
      return true if tir.is_charged?
    end
    return false
  end
end