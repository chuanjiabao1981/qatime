require 'test_helper'

class SoftwareTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "student visit download view" do
    student = users(:student1)
    log_in_as(student)
    visit info_student_path(student)
    click_on '下载'

    assert page.has_content?('答疑时间-android版'), '软件不能显示'
  end

  test "teacher visit download view" do
    teacher = users(:physics_teacher1)
    log_in_as(teacher)
    visit info_teacher_path(teacher)
    click_on '下载'

    assert page.has_content?('答疑时间-android版'), '软件不能显示'
  end
end
