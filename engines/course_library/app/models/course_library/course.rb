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


    has_many :customized_tutorials,class_name: "CustomizedTutorial",foreign_key: "template_id"



    def publish_all(customized_course_id)
      customized_tutorial   = CustomizedTutorial.create_from_template(customized_course_id,self)
      customized_tutorial
    end

    def un_publish(customized_tutorial_id)
      customized_tutorial = CustomizedTutorial.find_by(id: customized_tutorial_id)
      return false if customized_tutorial.nil? or customized_tutorial.is_any_component_charged?
      customized_tutorial.destroy
      return true
    end

    def sync_all(customized_tutorial_id)
      customized_tutorial = CustomizedTutorial.find_by(id: customized_tutorial_id)
      return false if customized_tutorial.nil? or customized_tutorial.is_any_component_charged?
      customized_tutorial.sync_with_template
      return true
    end



    def has_the_homework?(homework_id)
      self.homework_ids.include?(homework_id)
    end

    def available_customized_course_ids

    end

    def available_customized_course_ids=(arr)
      return if arr.nil?
      arr.each do |customized_course_id|
        self.publish_all(customized_course_id)
      end
    end

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
