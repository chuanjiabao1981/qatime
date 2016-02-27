module CourseLibrary
  module CoursePublicationService
    class CanLectureUnPublish
      def initialize(course_publication)
        @course_publication = course_publication
      end

      def call
        #如果以前就没有发布过当然可以UnPublish
        if @course_publication.publish_lecture_switch == false
          return true
        end

        if @course_publication.customized_tutorial.nil?
          return true
        end
        if @course_publication.customized_tutorial.is_charged?
          return false
        end

        return true

      end
    end
  end
end