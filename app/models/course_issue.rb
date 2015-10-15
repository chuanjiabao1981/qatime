class CourseIssue < Topic
  include QaIssue


  belongs_to :customized_course,counter_cache: true
  has_many :course_issue_replies,foreign_key: "topic_id"

end
