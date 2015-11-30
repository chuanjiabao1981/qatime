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


  test "change solution new to complete" do
    homework_solution = solutions(:homework_solution_one)
    visit homework_path(homework_solution.examination)
    find("div##{homework_solution.model_name.singular_route_key}-state-#{homework_solution.id}").click
    within("div##{homework_solution.model_name.singular_route_key}-state-#{homework_solution.id}") do
      click_on HomeworkSolution.human_state_event_name(:complete)
    end
    sleep 5
    within("div##{homework_solution.model_name.singular_route_key}-state-#{homework_solution.id}") do
      #通过这行来验证ajax返回了正确的button，如果不存在则会报异常
      find_button(HomeworkSolution.human_state_name(:completed))
    end
    page.save_screenshot("screenshot.png")
  end


end