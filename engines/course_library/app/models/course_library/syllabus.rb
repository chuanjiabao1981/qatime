module CourseLibrary
  class Syllabus < ActiveRecord::Base
    validates_presence_of :title, :description
    belongs_to :author, class_name: 'Teacher'
    has_many :directories

    def get_root_dir
      self.directories.find_by(parent: nil)
    end
  end
end
