require 'test_helper'



module QaTest
  module Shared
    module ExerciseCorrection
      module CourseLibrary
        class CreatePayedCorrectionFromTemplate
          # 给定一个来自于course_library的练习，
          # 给此练习创建一个学生完成作业，然后给此练习创建一个已经计费的批改
          def initialize(exercise)
            ##这个exercise一定是来自于course_library
            @exercise             = exercise
            @customized_course    = exercise.customized_tutorial.customized_course
            @correction_template  = exercise.homework_publication.homework.solutions.first
          end

          def call
            student_solution    = @exercise.exercise_solutions.build(title: random_str,last_operator: @customized_course.student)
            student_solution.save

            ec = ExerciseCorrectionService::CourseLibrary::BuildFromTemplate.new(student_solution,@correction_template.id).call
            ec.set_charged
            ec.save
            ec
          end
        end
      end
    end
  end
end