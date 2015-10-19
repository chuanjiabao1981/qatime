class TutorialIssueReply < Reply

  include QaIssueReply
  include Tally

  belongs_to :tutorial_issue,foreign_key: "topic_id"
  belongs_to :customized_tutorial
  belongs_to :customized_course





  def _notify_message
    "回复了#{TutorialIssue.model_name.human}，请关注"
  end
end