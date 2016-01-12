module TeachingProgram
  class Publishment < ActiveRecord::Base
    belongs_to :course, class_name: TeachingProgram::Course
    belongs_to :courseable,polymorphic: true
  end
end
