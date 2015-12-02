class QaCommonStateCahngeTest < ActionDispatch::IntegrationTest



  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @teacher  = users(:teacher1)
    log_in_as(@teacher)

  end

  def teardown
    logout_as(@teacher)

    Capybara.use_default_driver
  end


  test "change homework solution new to complete" do
    homework_solution         = solutions(:homework_solution_one)
    state_object_path         = homework_path(homework_solution.examination)
    change_state(homework_solution,state_object_path)
  end
  test "change exercise solution new to complete" do
    exercise_solution         = solutions(:exercise_solution_one)
    state_object_path         = exercise_path(exercise_solution.examination)
    change_state(exercise_solution,state_object_path)
  end

  private
  def change_state(state_object,state_object_path)
    state_object_class        = state_object.class
    state_object_model_name   = state_object.model_name
    visit state_object_path
    find("div##{state_object_model_name.singular_route_key}-state-#{state_object.id}").click
    within("div##{state_object_model_name.singular_route_key}-state-#{state_object.id}") do
      click_on state_object_class.human_state_event_name(:complete)
    end
    sleep 5
    within("div##{state_object_model_name.singular_route_key}-state-#{state_object.id}") do
      #通过这行来验证ajax返回了正确的button，如果不存在则会报异常
      find_button(state_object_class.human_state_name(:completed))
    end
    page.save_screenshot("screenshot.png")
  end


end