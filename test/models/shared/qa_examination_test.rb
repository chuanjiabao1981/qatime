require 'models/shared/utils/qa_test_factory'
require 'models/shared/qa_common_state_test'

module QaExaminationTest
  include QaCommonStateTest
  def check_examination_state_change_process examination
    check_first_handle_timestamp examination do |e|
      QaTestFactory::QaSolutionFactory.solution_create e,completed: true
    end

    check_complete_timestamp examination

    check_redo_timestamp examination
    #测试completed后再进行handle
    #exercise 要处于in_progress状态
    check_complete_timestamp examination
    check_handle_timestamp examination do |e|
      QaTestFactory::QaSolutionFactory.solution_create e,completed: false
    end
  end
end