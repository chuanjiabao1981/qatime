module CustomizedTutorialService
  module CourseLibrary
    class CreateExercisesFromPublications

      def initialize(homework_publications)
        @homework_publications  = homework_publications
      end

      def call
        return unless @homework_publications
        @homework_publications.each do |homework_publication|
          ExerciseService::CourseLibrary::CreateFromPublication.new(homework_publication).call
        end
      end
    end
  end
end
