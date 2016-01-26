class ExerciseCorrection < Correction
  include Tally

  belongs_to :exercise_solution,foreign_key: :solution_id
  belongs_to :exercise,foreign_key: :examination_id
  belongs_to :customized_course
  belongs_to :customized_tutorial
  belongs_to :template, class_name: CourseLibrary::Solution

  def template_id=(tt)
    super(tt)
  end

end