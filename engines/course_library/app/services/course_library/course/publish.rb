module CourseLibrary

  class Course::Publish
    def initialize(customized_course_ids,course)
      @customized_course_ids = customized_course_ids
      @course                = course
    end

    def call
      return if @customized_course_ids.nil?
      return if @course.nil?
      @customized_course_ids.each do |customized_course_id|
        CustomizedTutorial::CreateFromTemplate.new(customized_course_id,@course).call
      end
    end
  end
end