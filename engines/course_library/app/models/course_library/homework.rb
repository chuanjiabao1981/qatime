module CourseLibrary
  class Homework < ActiveRecord::Base
    validates_presence_of :title, :description
    belongs_to :course
    has_many :solutions
    include QaFileAccessor
  end
end
