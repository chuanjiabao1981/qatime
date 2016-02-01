class ExerciseSolution::AnyComponentCharged
  def initialize(exercise_solution)
    @exercise_solution = exercise_solution
  end

  def judge?
    @exercise_solution.exercise_corrections.each do |ec|
      return true if ec.is_charged?
    end
    return false
  end
end