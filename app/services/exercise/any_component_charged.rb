class Exercise::AnyComponentCharged
  def initialize(exercise)
    @exercise = exercise
  end

  def judge?
    @exercise.exercise_solutions.each do |es|
      return true if ExerciseSolution::AnyComponentCharged.new(es).judge?
    end
    return false
  end
end