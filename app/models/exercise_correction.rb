class ExerciseCorrection < Correction
  include Tally
  include QaTemplate::Video

  belongs_to :exercise_solution,foreign_key: :solution_id
  belongs_to :exercise,foreign_key: :examination_id
  belongs_to :customized_course
  belongs_to :customized_tutorial
  belongs_to :template, class_name: CourseLibrary::Solution
  validates_uniqueness_of :template_id ,scope: :examination_id, unless:  "template_id.nil?"
end
