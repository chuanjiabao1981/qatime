class CourseIssueReply < Reply

  include QaIssueReply

  belongs_to :course_issue,foreign_key: "topic_id"
  belongs_to :customized_course



  def _notify_message
    "回复了#{CourseIssue.model_name.human}请关注"
  end
end