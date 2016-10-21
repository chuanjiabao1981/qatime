require 'test_helper'

class SoftwaresTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "teacher visit download view" do
    teacher = users(:physics_teacher1)
    log_in_as(teacher)
    visit info_teacher_path(teacher)
    click_on '下载'

    assert page.has_content?('教师问答社区'), '软件不能显示'
    new_logout_as(teacher)
  end
end
