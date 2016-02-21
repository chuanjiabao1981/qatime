module ExerciseService
  module Fee
    class AnyComponentCharged
      def initialize(exercise)
        @exercise = exercise
      end

      def judge?
        @exercise.exercise_solutions.each do |es|
          return true if ExerciseSolutionService::Fee::AnyComponentCharged.new(es).judge?
        end
        return false
      end
    end
  end
end