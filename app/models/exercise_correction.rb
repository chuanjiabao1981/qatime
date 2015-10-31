class ExerciseCorrection < Correction
  include Tally
  belongs_to :exercise_solution,foreign_key: :solution_id
  belongs_to :exercise,foreign_key: :examination_id
  belongs_to :customized_course
  belongs_to :customized_tutorial

  def solution_name
    ExerciseSolution.model_name.human
  end
end