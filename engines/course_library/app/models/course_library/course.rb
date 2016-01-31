module CourseLibrary
  class Course < ActiveRecord::Base
    validates_presence_of :title, :description
    belongs_to :directory                                         
    has_one :video_quoter, as: :file_quoter, class_name: "VideoQuoter"
    has_one :video, through: :video_quoter, class_name: "Video"
    has_many :qa_file_quoters, as: :file_quoter, class_name: "QaFileQuoter"
    has_many :qa_files, through: :qa_file_quoters                 
    has_many :picture_quoters, as: :file_quoter, class_name: "PictureQuoter"
    has_many :pictures, through: :picture_quoters
    has_many :homeworks


    has_many :customized_tutorials,class_name: "CustomizedTutorial",foreign_key: "template_id"




    def has_the_homework?(homework_id)
      self.homework_ids.include?(homework_id)
    end

    def available_customized_course_ids

    end

    #TODO:: remove it from model
    def available_customized_course_for_publish
      teacher = self.author
      a = teacher.customized_courses
      b = []
      self.customized_tutorials.each do |ct|
        b << ct.customized_course
      end
      a - b
    end

    def author_id
      self.directory.syllabus.author.id
    end
    def author
      self.directory.syllabus.author
    end

  end
end
