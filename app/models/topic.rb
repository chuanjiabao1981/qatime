class Topic < ActiveRecord::Base

  include QaToken
  include ContentValidate
  include QaCommon
  include QaCustomizedCourseActionRecord
  include QaCommonState


  class TopicCompletedValidator < ActiveModel::Validator
    def validate(record)
      if record.replies_count == 0
        record.errors.add :base , :cant_complete
      end
    end
  end
  __create_state_machine(TopicCompletedValidator)



  belongs_to :author        ,:class_name => "User",:counter_cache => true,:inverse_of => :topics
  belongs_to :topicable     ,:polymorphic   => true        ,:counter_cache => true
  belongs_to :teacher
  belongs_to :last_operator ,:class_name => User
  has_many :replies,:dependent => :destroy

  self.per_page = 10

  scope :from_customized_course, lambda {where("customized_course_id is not null").order("created_at desc") }

  scope :by_customized_course_issue, lambda {where("type = ? or type = ?", TutorialIssue.to_s,CourseIssue.to_s)}
  scope :by_customized_course_ids,   lambda {|ids| where(customized_course_id: ids)}

  validates_presence_of :author,:last_operator


  def operator_id
    self.author_id
  end
end
