class HomeworkCorrection < Correction
  include Tally

  belongs_to :homework_solution,foreign_key: :solution_id
  belongs_to :homework,foreign_key:  :examination_id
  belongs_to :customized_course

end