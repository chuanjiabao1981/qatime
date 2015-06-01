module CurriculumsHelper
  #由于teaching program的helper函数还未产生，暂时放在这里
  def teaching_program_full_name(teaching_program)
    "#{teaching_program.grade} • #{teaching_program.subject} • #{teaching_program.name}"
  end
  def course_full_name(course)
    "#{course.chapter} - #{course.name}" if course
  end


  #这个是给form用的
  def get_curriculum_categories_collection(curriculum)
    a = get_curriculum_categories(curriculum)
    a.map {|c| [c,c] }
  end
  # 这个是个普通页面用的
  def get_curriculum_categories(curriculum)
    teaching_program            = curriculum.teaching_program
    default_categories          = APP_CONSTANT["lesson_categories"]["default"]
    default_categories2         = APP_CONSTANT["lesson_categories"][teaching_program.category]["default"]
    default_subject_categories  = []

    if APP_CONSTANT["lesson_categories"][teaching_program.category].has_key?(teaching_program.subject)
      default_subject_categories =  APP_CONSTANT["lesson_categories"][teaching_program.category][teaching_program.subject]
    end
    default_categories + default_categories2 + default_subject_categories
  end
end
