module CourseLibrary
  class Directory < ActiveRecord::Base
    validates_presence_of :title
    belongs_to :syllabus, class_name: CourseLibrary::Syllabus
    belongs_to :parent, class_name: CourseLibrary::Directory
    has_many :children, class_name: CourseLibrary::Directory
    has_many   :courses
  end
end
