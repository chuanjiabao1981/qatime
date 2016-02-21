module CourseLibrary
  module CoursePublicationService
    module Util
      class PublicationTotal
        def initialize(course,customized_course,options={})
          @course            = course
          @customized_course = customized_course
          @options           = options
        end

        def call
          course_publication = CoursePublication.new(course: @course,customized_course: @customized_course)
          if @options[:publish_lecture_switch]
            course_publication.publish_lecture_switch = true
          end
          course_publication.save!

          @course.homeworks.each do |h|
            homework_publication  = HomeworkPublication.new(course_publication: course_publication,homework:h)
            homework_publication.save!
          end
          course_publication
        end
      end
    end
  end
end