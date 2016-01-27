module CourseLibrary
  class Course < ActiveRecord::Base
    validates_presence_of :title, :description
    belongs_to :directory
    include VideoAccessor
    include QaFileAccessor
    has_many :homeworks
    def self.get_all_courses(teacher)
      @syllabuses = Syllabus.where(author: teacher)
      @directories = Directory.where(syllabus: @syllabuses)
      @courses = Course.where(directory: @directories)
    end
  end
end
