class CustomizedCourse < ActiveRecord::Base
  belongs_to :student
  has_many :customized_course_assignments,:dependent => :destroy
  has_many :teachers,:through => :customized_course_assignments
  has_many :customized_tutorials,:dependent => :destroy
  validates_presence_of :subject,:category,:student
end
