module CourseLibrary
  class Course < ActiveRecord::Base

    include VideoAccessor
    include QaFileAccessor
    include PictureAccessor


    validates_presence_of :title, :description
    belongs_to :directory
    acts_as_list scope: :directory

    has_many :homeworks

    has_many :course_publications

    def self.get_all_courses(teacher)
      @syllabuses = Syllabus.where(author: teacher)
      @directories = Directory.where(syllabus: @syllabuses)
      @courses = Course.where(directory: @directories)
    end



    def has_lecture?
      return true if not video.nil? or qa_files.length > 0 or  pictures.length > 0
      false
    end


    def has_the_homework?(homework_id)
      self.homework_ids.include?(homework_id)
    end

    def available_customized_course_ids

    end


    def author_id
      self.directory.syllabus.author.id
    end
    def author
      self.directory.syllabus.author
    end

  end
end
