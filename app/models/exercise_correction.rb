class ExerciseCorrection < Correction
  include Tally
  belongs_to :exercise_solution,foreign_key: :solution_id
  belongs_to :customized_course
end