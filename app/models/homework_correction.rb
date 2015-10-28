class HomeworkCorrection < Correction
  include Tally
  include QaActionRecord

  belongs_to        :homework_solution,foreign_key: :solution_id
  belongs_to        :homework,foreign_key:  :examination_id
  belongs_to        :customized_course



  def solution_name
    HomeworkSolution.model_name.human
  end
end