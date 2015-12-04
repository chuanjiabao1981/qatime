require 'models/shared/utils/qa_test_factory'
require 'models/shared/qa_common_state_test'

module QaExaminationTest
  include QaCommonStateTest
  def check_examination_state_change_process(examination)
    check_first_handle_timestamp examination do |e|
      QaTestFactory::QaSolutionFactory.create e,completed: true
    end

    check_complete_timestamp examination

    check_redo_timestamp examination
    #测试completed后再进行handle
    #exercise 要处于in_progress状态
    check_complete_timestamp examination
    check_handle_timestamp examination do |e|
      QaTestFactory::QaSolutionFactory.create e,completed: false
    end
  end

  # 如果examination当前处于completed状态，修改了examination.solution状态到progress
  # 则examination的状态要处于in_progress
  def check_examination_complete_change(examination)
    # 先把examination设置到complete
    QaTestFactory::QaSolutionFactory.create examination,completed: true
    examination.reload
    check_complete_timestamp examination

    # 把solution的状态修改为in_progress
    if examination.instance_of? Homework
      solutions = examination.homework_solutions
    elsif examination.instance_of? Exercise
      solutions = examination.exercise_solutions
    end
    solution    =  solutions.first
    assert solution.state == "completed"

    check_redo_timestamp solution
    # 检查examination的状态为in_progress
    assert examination.reload.state == "in_progress"
  end
  #examination没有solution的情况
  def check_cant_complete_1(examination)
    assert examination.solutions.length == 0
    examination.state_event     = :complete
    assert_not examination.valid?
    assert examination.errors.added? :base,:cant_complete_solutions_zero
  end

  #examination有solution，但是状态不是complete
  def check_cant_complete_2(examination)
    assert examination.solutions.length == 0
    QaTestFactory::QaSolutionFactory.create examination,completed: false
    examination.reload
    examination.state_event     = :complete
    assert_not examination.valid?
    assert examination.errors.added? :base,:cant_complete_solutions_not_complete
  end
end