module QaTestFactory
  module QaCorrectionFactory

    def correction_build(solution)
      if solution.instance_of?(HomeworkSolution)
        correction = solution.homework_corrections.build(content: random_str,
                                                   last_operator: solution.examination.teacher,
                                                   teacher: solution.examination.teacher
                                                    )
      elsif solution.instance_of?(ExerciseSolution)
        correction = solution.exercise_corrections.build(content: random_str,
                                                   last_operator: solution.examination.teacher,
                                                   teacher: solution.examination.teacher
        )
      end
      correction
    end

    def correction_create(solution)
      correction = correction_build(solution)
      correction.save!
      correction
    end
  end

  module QaSolutionFactory
    def solution_build(examination)
      student = examination.customized_course.student
      if examination.instance_of?(Homework)
        solution  = examination.homework_solutions.build(title: random_str,
                                                         content: random_str,
                                                         student: student,
                                                         last_operator: student
                                                        )
      elsif examination.instance_of?(Exercise)
        solution  = examination.exercise_solutions.build(title: random_str,
                                                         content: random_str,
                                                         student: student,
                                                         last_operator: student
                                                        )
      end
      solution
    end

    def solution_create(examination,opt={})
      solution = solution_build(examination)
      if opt[:completed]
        QaCorrectionFactory::correction_create(solution)
        solution.state_event = :complete
      end
      solution.save!
      solution
    end
  end

end
