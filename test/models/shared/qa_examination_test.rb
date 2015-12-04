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