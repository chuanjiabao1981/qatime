require 'test_helper'
require 'services/exercise_correction_service/course_library/template_test'

module ExerciseCorrectionServiceTest
  module CourseLibraryTest
    class BuildFromTemplateTest < TemplateTest
      test "create " do

        ec = ExerciseCorrectionService::CourseLibrary::BuildFromTemplate.new(@student_solution,@correction_template.id).call
        assert_not ec.template.nil?
        assert ec.valid?,ec.errors.full_messages

        assert ExerciseCorrectionService::CourseLibrary::SameWithTemplate.new(ec).judge?
      end
    end
  end
end