module Exam
  class Answer < ActiveRecord::Base
    belongs_to :result

    validates :content, :topic_id, presence: true
    validates :result, presence: true
  end
end
