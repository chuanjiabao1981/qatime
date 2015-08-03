class CustomizedTutorialCreateTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @teacher  = users(:teacher1)
    @customized_course =  customized_courses(:customized_course1)

  end

  def teardown
    #@headless.destroy

    visit get_home_url(@teacher)
    click_on '登出系统'
    Capybara.use_default_driver
  end

  test 'customized tutorial create' do
    log_in_as(@teacher)

    visit new_customized_course_customized_tutorial_path(@customized_course)
    page.save_screenshot('screenshot.png')
  end
end