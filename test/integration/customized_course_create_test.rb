class CustomizedCourseCreateTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @manager  = users(:manager)
  end

  def teardown
    #@headless.destroy

    visit get_home_url(@manager)
    click_on '登出系统'
    Capybara.use_default_driver
  end


  test "customized course create" do
    log_in_as(@manager)
    student1 = users(:student1)
    visit new_student_customized_course_path(student1)
    options = {from: 'customized-courses-teachers'}
    field = find_field('customized-courses-teachers',visible: false)
    print page.html
  end
end