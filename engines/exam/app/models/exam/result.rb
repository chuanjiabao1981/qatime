module Exam
  class Result < ActiveRecord::Base
    enum status: { init: 0, pending: 1, finished: 2 }

    belongs_to :paper
    belongs_to :ticket
    belongs_to :student, class_name: '::Student'

    has_many :answers, class_name: '::Exam::Answer'
    accepts_nested_attributes_for :answers
  end
end
