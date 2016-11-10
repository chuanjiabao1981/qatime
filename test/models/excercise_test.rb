require 'test_helper'
require 'models/shared/qa_common_state_test'
require 'models/shared/utils/qa_test_factory'
require 'models/shared/qa_examination_test'

class ExcerciseTest < ActiveSupport::TestCase

  include QaCommonStateTest
  include QaExaminationTest
  self.use_transactional_tests = true

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

  test "exercise state change notification" do
    exercise                 = examinations(:exercise_for_state_change_success)
    check_state_change_record(exercise)
  end

  test "exercise state change process" do
    exercise                 = examinations(:exercise_for_state_change)
    check_examination_state_change_process(exercise)
  end


  test "exercise cant complete 1" do
    #没有solution的时候
    exercise                 = examinations(:exercise_for_state_change)
    check_cant_complete_1 exercise
  end

  test "exercise cant complete 2" do
    #有solution，但是状态不是complete
    exercise                 = examinations(:exercise_for_state_change)
    check_cant_complete_2(exercise)
  end


  test "exercise complete to in progress" do
    exercise                 = examinations(:exercise_for_state_change)
    check_examination_complete_change(exercise)
  end



end
