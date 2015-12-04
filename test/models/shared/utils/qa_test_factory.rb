module QaTestFactory
  def QaTestFactory.random_str
    (0...50).map { ('a'..'z').to_a[rand(26)] }.join
  end
  module QaCorrectionFactory

    def QaCorrectionFactory.build(solution)
      if solution.instance_of?(HomeworkSolution)
        correction = solution.homework_corrections.build(content: QaTestFactory.random_str,
                                                   last_operator: solution.examination.teacher,
                                                   teacher: solution.examination.teacher
                                                    )
      elsif solution.instance_of?(ExerciseSolution)
        correction = solution.exercise_corrections.build(content: QaTestFactory.random_str,
                                                   last_operator: solution.examination.teacher,
                                                   teacher: solution.examination.teacher
        )
      end
      correction
    end

    def QaCorrectionFactory.create(solution)
      correction = build(solution)
      correction.save!
      correction
    end
  end

  module QaSolutionFactory
    def QaSolutionFactory.build(examination)
      student = examination.customized_course.student
      if examination.instance_of?(Homework)
        solution  = examination.homework_solutions.build(title: QaTestFactory.random_str,
                                                         content: QaTestFactory.random_str,
                                                         student: student,
                                                         last_operator: student
                                                        )
      elsif examination.instance_of?(Exercise)
        solution  = examination.exercise_solutions.build(title: QaTestFactory.random_str,
                                                         content: QaTestFactory.random_str,
                                                         student: student,
                                                         last_operator: student
                                                        )
      end
      solution
    end

    def QaSolutionFactory.create(examination,opt={})
      solution = build(examination)
      solution.save!
      if opt[:completed]
        QaCorrectionFactory.create(solution)
        solution.reload
        solution.state_event = :complete
        solution.save!
      end
      solution
    end
  end

end
