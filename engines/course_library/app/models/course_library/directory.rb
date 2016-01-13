module CourseLibrary
  class Directory < ActiveRecord::Base
    validates_presence_of :title
    belongs_to :parent, polymorphic: true
    has_many   :courses 
  end
end
