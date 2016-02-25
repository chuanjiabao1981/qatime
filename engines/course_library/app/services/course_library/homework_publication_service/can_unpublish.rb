module CourseLibrary
  module HomeworkPublicationService
    class CanUnPublish
      def initialize(course_publication,homework_id,options={})
        course_publication      = course_publication
        homework_id             = homework_id
        homework_publication    = __get_homework_publication(course_publication,homework_id)
        exercise                = nil
        if not homework_publication.nil?
          exercise              = homework_publication.exercise
        end
        if options[:fee]
          @fee                  = options[:fee]
        else
          @fee                  = ExerciseService::Fee::AnyComponentCharged.new(exercise)
        end
      end

      def call
        if @fee.judge?
          return true
        end
        return false
      end

      private
      def __get_homework_publication(course_publication,homework_id)
        course_publication.homework_publication.find_by_homework_id(homework_id)
      end
    end
  end
end