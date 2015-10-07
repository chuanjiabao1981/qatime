class TutorialIssue < ActiveRecord::Base
  belongs_to :customized_tutorial,counter_cache: true
  belongs_to :customized_course,counter_cache: true
  belongs_to :student
  belongs_to :teacher

  has_one :topic,as: :topicable,dependent: :destroy
end
