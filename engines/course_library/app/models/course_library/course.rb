module CourseLibrary
  class Course < ActiveRecord::Base
    validates_presence_of :title, :description
    belongs_to :directory
    include VideoAccessor
    has_many :qa_file_quoters, as: :file_quoter, class_name: "QaFileQuoter"
    has_many :qa_files, through: :qa_file_quoters                 
    has_many :picture_quoters, as: :file_quoter, class_name: "PictureQuoter"
    has_many :pictures, through: :picture_quoters
    has_many :homeworks
    def self.get_all_courses(teacher)
      @syllabuses = Syllabus.where(author: teacher)
      @directories = Directory.where(syllabus: @syllabuses)
      @courses = Course.where(directory: @directories)
    end
  end
end
