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
      self.publish_homeworks_to_customized_tutorial(customized_tutorial)
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

    def publish_homeworks_to_customized_tutorial(customized_tutorial)
      exercises                     = customized_tutorial.exercises
      already_published_homework    = []
      exercises.each do |e|
        if e.template
          already_published_homework << e.template.id
        end
      end
      self.homeworks.each do |homework|
        if not already_published_homework.include?(homework.id)
          self.publish_homework_to_customized_tutorial(homework,customized_tutorial)
        end
      end
    end

    def publish_homework_to_customized_tutorial(homework,customized_tutorial)
      exercise = customized_tutorial.exercises.build(customized_course_id: customized_tutorial.customized_course_id,
                                                     template_id: homework.id,
                                                     teacher_id:  self.author_id,
                                                     last_operator_id: self.author_id,
                                                     title: homework.title,
                                                     content: homework.description,
                                                     student_id: customized_tutorial.customized_course.student.id
      )
      exercise.template_file_ids      = homework.qa_file_ids
      exercise.template_picture_ids   = homework.picture_ids
    end

    def syn_lecture_with_customized_tutorial(customized_tutorial)
      customized_tutorial.title                 = self.title
      customized_tutorial.content               = self.description
      customized_tutorial.template_video        = self.video
      customized_tutorial.template_picture_ids  = self.picture_ids
      customized_tutorial.template_file_ids     = self.qa_file_ids
      customized_tutorial
    end

    def syn_homeworks_with_customized_tutorial(customized_tutorial)
      customized_tutorial.exercises.each do |exercise|
        syn_homework_with_exercise(exercise)
      end
      #把新加的作业也同步过去
      self.publish_homeworks_to_customized_tutorial(customized_tutorial)
      customized_tutorial.save
    end

    def syn_homework_with_exercise(exercise)
      h = exercise.template
      return if h.nil?  #TODO:: 删除自己
      exercise.title                  =   h.title
      exercise.content                =   h.description
      exercise.template_file_ids      =   h.qa_file_ids
      exercise.template_picture_ids   =   h.picture_ids
      exercise
    end




    def is_same_lecture?(customized_tutorial)
      diff = []
      if customized_tutorial.title != self.title
        diff << "title"
      end
      if (customized_tutorial.content != self.description)
        diff << "description"
      end
      if customized_tutorial.template_video  != self.video
        diff << "video"
      end

      p1 = customized_tutorial.template_picture_ids || []
      p2 = self.picture_ids || []

      if not (p1 - p2).blank?
        diff << "pictures"
      end

      f1 = customized_tutorial.template_file_ids || []
      f2 = self.qa_file_ids || []

      if not (f1-f2).blank?
        diff << "files"
      end
      # puts diff
      if diff.blank?
        return true
      end
      return false
    end

    def is_same_homework?(exercise)
      diff = []
      homework = exercise.template
      if homework.nil?
        diff << "not exsits"
        return false
      end
      if homework.title != exercise.title
        puts homework.title,exercise.title
        diff << "title"
      end
      if homework.description != exercise.content
        diff << "description"
      end
      p1 = homework.picture_ids || []
      p2 = exercise.template_picture_ids || []
      if not (p1-p2).blank?
        diff << "picture"
      end

      f1 = homework.qa_file_ids || []
      f2 = exercise.template_picture_ids || []

      if not (f1-f2).blank?
        diff << "files"
      end
      if diff.blank?
        return true
      end
      return false
    end

    def author_id
      self.directory.syllabus.author.id
    end
  end
end
