module CourseLibrary
  class Syllabus < ActiveRecord::Base
    validates_presence_of :title, :description
    belongs_to :author, class_name: 'Teacher'
    has_one :directory, as: :parent
  end
end
