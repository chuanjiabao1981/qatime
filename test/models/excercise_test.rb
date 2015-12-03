require 'test_helper'
require 'models/shared/qa_common_state_test'
require 'models/shared/utils/qa_test_factory'
require 'models/shared/qa_examination_test'

class ExcerciseTest < ActiveSupport::TestCase

  include QaCommonStateTest
  include QaExaminationTest
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

  test "exercise state change process" do
    exercise                 = examinations(:exercise_for_state_change)
    check_examination_state_change_process(exercise)
    # check_first_handle_timestamp exercise do |e|
    #   QaTestFactory::QaSolutionFactory.solution_create e,completed: true
    # end
    #
    # check_complete_timestamp exercise
    #
    # check_redo_timestamp exercise
    # #测试completed后再进行handle
    # #exercise 要处于in_progress状态
    # check_complete_timestamp exercise
    # check_handle_timestamp exercise do |e|
    #   QaTestFactory::QaSolutionFactory.solution_create e,completed: false
    # end
  end


  test "exercise cant complete 1" do
    #没有solution的时候
    exercise                 = examinations(:exercise_for_state_change)
    assert exercise.solutions.length == 0
    exercise.state_event     = :complete
    exercise.valid?
    assert exercise.errors.added? :base,:cant_complete_solutions_zero
  end

  test "exercise cant complete 2" do
    #有solution，但是状态不是complete
    exercise                 = examinations(:exercise_for_state_change)
    assert exercise.solutions.length == 0
    QaTestFactory::QaSolutionFactory.solution_create exercise,completed: false
    exercise.reload
    exercise.state_event     = :complete
    exercise.valid?
    puts exercise.errors.values
    assert exercise.errors.added? :base,:cant_complete_solutions_not_complete
  end



end
