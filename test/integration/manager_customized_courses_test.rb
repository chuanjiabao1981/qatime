require 'test_helper'

class ManagerCustomizedCoursesTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @manager = users(:manager)
    new_log_in_as(@manager)
  end

  def teardown
    new_logout_as(@manager)
    Capybara.use_default_driver
  end

  test "visit customized_courses page" do
    visit managers_home_path
    click_on '课程管理'
    click_on '专属课程'
    assert page.has_content?('讲师')
    assert page.has_content?('是否计费')
    assert page.has_content?('超过3天未写的家庭作业数量')
    assert page.has_link?('高中-数学')
  end
end
