module CourseLibrary
  class Homework < ActiveRecord::Base
    validates_presence_of :title, :description
    belongs_to :course
    has_many :solutions
    include QaFileAccessor
    include PictureAccessor
    has_many :exercises,class_name: "Exercise",foreign_key: "template_id"



  end
end
