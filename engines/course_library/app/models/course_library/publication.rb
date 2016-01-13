module CourseLibrary
  class Publication < ActiveRecord::Base
    belongs_to :course,class_name: CourseLibrary::Course
    belongs_to :courseable ,polymorphic: true
  end
end
