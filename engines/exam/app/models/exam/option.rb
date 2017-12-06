module Exam
  class Option < ActiveRecord::Base
    belongs_to :topic
  end
end
