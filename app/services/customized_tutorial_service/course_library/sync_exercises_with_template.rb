module CustomizedTutorialService
  module CourseLibrary
    class SyncExercisesWithTemplate
      def initialize(customized_tutorial)
        @customized_tutorial = customized_tutorial
      end

      def call
        @customized_tutorial.exercises.each do |exercise|
          ExerciseService::CourseLibrary::SyncWithTemplate.new(exercise).call
        end
      end
    end
  end
end