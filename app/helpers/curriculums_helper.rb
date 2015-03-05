module CurriculumsHelper
  #由于teaching program的helper函数还未产生，暂时放在这里
  def teaching_program_full_name(teaching_program)
    "#{teaching_program.grade} • #{teaching_program.subject} • #{teaching_program.name}"
  end
end
