class CourseIssue < Topic
  include QaIssue
  include QaCommon

  belongs_to :customized_course, counter_cache: true
  has_many :course_issue_replies, foreign_key: "topic_id", dependent: :destroy do
    include QaPageNum

    def build(attributes = {})
      attributes[:customized_course_id] = proxy_association.owner.customized_course_id
      super attributes
    end

    def page_num(o)
      _page_num(o, by: Reply.order_column, order: Reply.order_type, per: Reply.per_page)
    end
  end
end
