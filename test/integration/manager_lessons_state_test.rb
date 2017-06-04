require 'test_helper'

class ManagerLessonsStateTest < ActionDispatch::IntegrationTest
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

  test "visit home lessons state" do
    visit managers_home_path
    click_on '课程管理'
    click_on '公共课程'
    assert page.has_content?('课程状态')
    assert page.has_link?('查看公共课程页面')
    assert page.has_link?('审核中')
    assert page.has_link?('已发布')
    assert page.has_link?('被驳回')
  end
end
