class HomeworkCorrection < Correction
  include Tally

  belongs_to :homework_solution,counter_cache: true
  belongs_to :homework,counter_cache: true
  belongs_to :customized_course
end