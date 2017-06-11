require 'test_helper'

class StudentViewTopAndSideBarTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "unsigned view top and side bar" do
    visit root_path

    assert find('div.navbar-collapse').has_content?('选课中心')
    assert find('div.navbar-collapse').has_content?('全部老师')
    find('div.navbar-collapse .nav-hover').hover
    assert find('div.navbar-collapse').has_content?('专属课程')
    assert find('div.navbar-collapse').has_content?('问答社区')
    assert find('div.navbar-collapse').has_content?('公共课程')
  end

  test "manager view top and side bar" do
    manager = users(:manager)
    log_in_as(manager)
    assert page.has_content?(manager.role.capitalize)
    assert page.has_link?('首页')
    assert page.has_link?('工作站信息')
    assert page.has_link?('资源管理')
    assert page.has_link?('课程管理')
    assert page.has_link?('网页管理')
    assert page.has_link?('课程代销')
    assert page.has_link?('员工管理')
    new_logout_as(manager)
  end

  test "admin view top bar" do
    admin = users(:admin)
    log_in_as(admin)

    assert find('div.navbar-collapse').has_content?('首页'), 'topbar首页不存在'
    assert find('div.navbar-collapse').has_content?('下载'), 'topbar下载不存在'
    assert find('div.navbar-collapse').has_content?('帮助'), 'topbar帮助不存在'

    new_logout_as(admin)
  end
end
