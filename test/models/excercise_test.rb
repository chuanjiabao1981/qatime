require 'test_helper'
require 'models/shared/qa_common_state_test'


class ExcerciseTest < ActiveSupport::TestCase

  include QaCommonStateTest
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

  test "exercise timestamp" do
    exercise                 = examinations(:exercise_for_state_change_success)
    check_state_timestamp(exercise)
  end

  test "exercise state change timestamp" do
    exercise                 = examinations(:exercise_for_state_change)
    student                  = exercise.customized_course.student
    check_first_handle_timestamp exercise do |e|
      solution = e.exercise_solutions.build(title: 111,content: 2222,student: student,last_operator: student)
      assert solution.save
    end
  end

end
