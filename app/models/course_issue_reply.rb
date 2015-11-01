class CourseIssueReply < Reply

  include QaIssueReply
  include Tally
  belongs_to :course_issue,foreign_key: "topic_id"
  belongs_to :customized_course

end