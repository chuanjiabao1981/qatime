module Exam
  class Ticket < ActiveRecord::Base
    belongs_to :student, class_name: '::Student'
    belongs_to :product, polymorphic: true
  end
end
