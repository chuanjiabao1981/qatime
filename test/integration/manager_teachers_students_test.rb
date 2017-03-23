require 'test_helper'

class ManagerTeachersStudentsTest < ActionDispatch::IntegrationTest

  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @manager = users(:manager)
    log_in_as(@manager)
  end

  def teardown
    new_logout_as(@manager)
    Capybara.use_default_driver
  end

  test "visit my teachers" do
    click_on '教师'
    assert page.has_link?('教师列表')
    assert_equal Teacher.by_city(@manager.city_id).count, all('.qa_box div.row').size - 2, '工作站城市下的老师未区分'
  end

  test "visit my students" do
    click_on '学生'
    assert page.has_link?('学生列表')
    assert_equal Student.by_city(@manager.city_id).count, all('.qa_box div.row').size - 2, '工作站城市下的学生未区分'
  end


end
