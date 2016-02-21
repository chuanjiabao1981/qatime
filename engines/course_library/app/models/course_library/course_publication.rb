module CourseLibrary
  class CoursePublication < ActiveRecord::Base

    include CourseLibrary::Concerns::CoursePublication::Common

    belongs_to :course
    belongs_to :customized_course

    has_one  :customized_tutorial
    has_many :homework_publications
    has_many :homeworks,through: :homework_publications

    validates_uniqueness_of :customized_course_id ,scope: :course_id
    validates_presence_of :customized_course
  end
end
