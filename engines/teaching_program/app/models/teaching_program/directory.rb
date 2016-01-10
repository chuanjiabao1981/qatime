module TeachingProgram
  class Directory < ActiveRecord::Base
    belongs to :parent, class_name: 'TeachingProgram::Directory'
    belongs to :syllabus, class_name: 'TeachingProgram::Syllabus'
    has_many   :courses   
  end
end
