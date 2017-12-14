module Exam
  class Result < ActiveRecord::Base
    belongs_to :paper
    belongs_to :ticket
    belongs_to :student

    has_many :answers, class_name: '::Exam::Answer'
    accepts_nested_attributes_for :answers
  end
end
