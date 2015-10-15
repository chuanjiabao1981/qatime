class TutorialIssue < Topic

  include QaIssue

  belongs_to :customized_tutorial,counter_cache: true
  belongs_to :customized_course,counter_cache: true
  has_many :tutorial_issue_replies,foreign_key: "topic_id" ,dependent: :destroy do
    def build(attributes={})
      attributes[:customized_course_id]       = proxy_association.owner.customized_course_id
      attributes[:customized_tutorial_id]     = proxy_association.owner.customized_tutorial_id
      super attributes
    end
  end


end
