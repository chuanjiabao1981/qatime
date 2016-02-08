require 'test_helper'


module ExerciseCorrectionServiceTest
  class TemplateTest  < ActiveSupport::TestCase
    def setup
      @course_one              = course_library_courses(:course_one)
      @correction_template     = course_library_solutions(:solution_one_for_homework_one)
      @customized_course       = customized_courses(:customized_course1)

      assert @correction_template.valid?
      @customized_tutorial     = CustomizedTutorial::CreateFromTemplate.new(@customized_course.id,@course_one).call
      exercise            = nil
      @customized_tutorial.exercises.each do |e|
        if e.template_id == @correction_template.homework_id
          exercise = e
        end
      end
      assert exercise.valid?

      @student_solution = exercise.exercise_solutions.build(title: random_str,last_operator: @customized_course.student)
      @student_solution.save
      assert @student_solution.valid?,@student_solution.errors.full_messages

    end
  end
end