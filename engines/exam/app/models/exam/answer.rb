module Exam
  class Answer < ActiveRecord::Base
    belongs_to :result
  end
end
