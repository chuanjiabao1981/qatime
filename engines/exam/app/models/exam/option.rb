module Exam
  class Option < ActiveRecord::Base
    belongs_to :topic, class_name: 'Exam::Topic'
  end
end
