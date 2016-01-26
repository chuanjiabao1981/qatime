require 'test_helper'

module Customized
  class ExerciseCorrectionCreateFromTemplate  < ActiveSupport::TestCase
    def setup
      @course_one              = course_library_courses(:course_one)
      @correction_template     = course_library_solutions(:solution_one_for_homework_one)
      @customized_course       = customized_courses(:customized_course1)
    end

    test "create " do
      assert @correction_template.valid?
      customized_tutorial = @course_one.publish_all(@customized_course.id)
      exercise            = nil
      customized_tutorial.exercises.each do |e|
        if e.template_id == @correction_template.homework_id
          exercise = e
        end
      end
      assert exercise.valid?

      
    end
  end
end