require 'test_helper'
require 'services/exercise_correction/template_test'

module ExerciseCorrectionServiceTest
  class BuildFromTemplateTest < TemplateTest


    test "create " do

      ec = ExerciseCorrection::BuildFromTemplate.new(@student_solution,@correction_template.id).call
      assert_not ec.template.nil?
      assert ec.valid?,ec.errors.full_messages

      assert ExerciseCorrection::SameWithTemplate.new(ec).judge?
    end
  end
end