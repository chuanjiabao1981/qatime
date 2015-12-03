require 'test_helper'
require 'models/shared/qa_common_state_test'
require 'models/shared/utils/qa_test_factory'

class ExcerciseTest < ActiveSupport::TestCase

  include QaCommonStateTest
  include QaTestFactory::QaSolutionFactory
  self.use_transactional_fixtures = true

  test "build" do
    @customized_tutorial    = customized_tutorials(:customized_tutorial1)

    exercise                = @customized_tutorial.exercises.build(title: "1234",content: "12341")
    exercise.teacher        = @customized_tutorial.teacher
    exercise.last_operator  = @customized_tutorial.teacher
    assert exercise.valid?,exercise.errors.full_messages
    assert exercise.customized_course.valid?
    assert exercise.customized_tutorial.valid?
    assert_difference '@customized_tutorial.reload.exercises_count',1 do
      assert_difference '@customized_tutorial.customized_course.reload.exercises_count',1 do
        assert_difference 'CustomizedCourseActionRecord.count',1 do
          assert_difference 'CustomizedCourseActionNotification.count',2 do
            exercise.save!
          end
        end
      end
    end
  end

  test "exercise state change success" do
    exercise                 = examinations(:exercise_for_state_change_success)
    check_state_change_record(exercise)
  end

  test "exercise state change timestamp" do
    exercise                 = examinations(:exercise_for_state_change)
    check_first_handle_timestamp exercise do |e|
      solution_create e,completed: true
    end
    exercise.exercise_solutions.each do |e|
      puts e.to_json
    end
    check_complete_timestamp exercise
  end



end
