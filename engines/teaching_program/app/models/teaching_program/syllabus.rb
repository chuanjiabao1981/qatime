module TeachingProgram
  class Syllabus < ActiveRecord::Base
    # belongs to :author, class_name: 'Teacher'
    # validates_presence_of :title, :description
  end
end
