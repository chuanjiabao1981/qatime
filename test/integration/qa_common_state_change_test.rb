require 'test_helper'
require 'models/shared/utils/qa_test_factory'


class QaCommonStateCahngeTest < ActionDispatch::IntegrationTest


  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @teacher  = users(:teacher1)
    log_in_as(@teacher)

  end

  def teardown
    new_logout_as(@teacher)

    Capybara.use_default_driver
  end


  test "change homework solution new to complete" do
    homework_solution         = solutions(:homework_solution_one)
    state_object_path         = homework_solution_path(homework_solution)
    change_state(homework_solution,state_object_path)
  end
  test "change exercise solution new to complete" do
    exercise_solution         = solutions(:exercise_solution_one)
    state_object_path         = exercise_solution_path(exercise_solution)
    change_state(exercise_solution,state_object_path)
  end

  test "change homework new to complete" do
    homework                      = examinations(:homwork_for_ui_state_change)
    state_object_path             = homework_path(homework)
    change_state(homework,state_object_path)
  end

  test "change exercise in_progress to complete" do
    exercise                      = examinations(:exercise_for_ui_state_change)
    state_object_path             = exercise_path(exercise)

    change_state(exercise,state_object_path)
  end

  test "change course issue in progress to complete" do
    course_issue                  = topics(:course_issue_for_ui_state_change)
    state_object_path             = course_issue_path(course_issue)
    change_state(course_issue,state_object_path)

  end

  test "change tutorial issue in progress to complete" do
    tutorial_issue              = topics(:tutorial_issue_for_ui_state_change)
    state_object_path           = tutorial_issue_path(tutorial_issue)
    change_state(tutorial_issue,state_object_path)

  end

  private
  def change_state(state_object,state_object_path)
    assert state_object.valid?
    state_object_class        = state_object.class
    state_object_model_name   = state_object.model_name
    visit state_object_path
    # page.save_screenshot("screenshot.png")

    find("div##{state_object_model_name.singular_route_key}-state-#{state_object.id}").click
    within("div##{state_object_model_name.singular_route_key}-state-#{state_object.id}") do
      click_on state_object_class.human_state_event_name(:complete)
    end
    # sleep 5
    page.save_screenshot("screenshots/screenshot.png")

    within("div##{state_object_model_name.singular_route_key}-state-#{state_object.id}") do
      #如果不存在则会报异常
      find_button(state_object_class.human_state_name(:completed))
    end
  end


end
