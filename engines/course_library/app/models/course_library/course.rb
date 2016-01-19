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



    def publish_all(customized_course_id)
      customized_tutorial = self.publish_lecture_to_customized_course(customized_course_id)
      self.publish_homework_to_customized_tutorial(customized_tutorial)
      customized_tutorial
    end
    def publish_lecture_to_customized_course(customized_course_id)

      a = self.customized_tutorials.build(customized_course_id: customized_course_id,
                                      title: self.title,
                                      content: self.description,
                                      teacher_id: self.directory.syllabus.author.id,
                                      last_operator_id: self.author_id
      )

      a.template_video        = self.video
      a.template_picture_ids  = self.picture_ids
      a.template_file_ids     = self.qa_file_ids

      a
    end

    def publish_homework_to_customized_tutorial(customized_tutorial)
      self.homeworks.each do |h|
        exercise = customized_tutorial.exercises.build(customized_course_id: customized_tutorial.customized_course_id,
                               template_id: h.id,
                               teacher_id:  self.author_id,
                               last_operator_id: self.author_id,
                               title: self.title,
                               content: self.description,
                               student_id: customized_tutorial.customized_course.student.id
        )
        exercise.template_file_ids      = h.qa_file_ids
        exercise.template_picture_ids   = h.picture_ids
      end
    end

    def syn_lecture_with_customized_tutorial(customized_tutorial)
      customized_tutorial.title                 = self.title
      customized_tutorial.content               = self.description
      customized_tutorial.template_video        = self.video
      customized_tutorial.template_picture_ids  = self.picture_ids
      customized_tutorial.template_file_ids     = self.qa_file_ids
      customized_tutorial
    end




    def is_same_lecture?(customized_tutorial)
      return false if customized_tutorial.title     != self.title
      return false if customized_tutorial.content     != self.description
      return false if customized_tutorial.template_video
    end

    def author_id
      self.directory.syllabus.author.id
    end
  end
end
