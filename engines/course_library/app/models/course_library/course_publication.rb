module CourseLibrary
  class CoursePublication < ActiveRecord::Base


    belongs_to :course
    belongs_to :customized_course

    has_one  :customized_tutorial,:dependent => :destroy
    has_many :homework_publications,:dependent => :destroy

    has_many :homeworks,through: :homework_publications

    validates_uniqueness_of :customized_course_id ,scope: :course_id
    validates_presence_of :customized_course
  end
end
