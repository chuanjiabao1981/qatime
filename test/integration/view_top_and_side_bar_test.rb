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

    assert find('div.navbar-collapse').has_content?('直播课')
    assert find('div.navbar-collapse').has_content?('一对一')
    assert find('div.navbar-collapse').has_content?('视频课')
    assert find('div.navbar-collapse').has_content?('专属课程')
    assert find('div.navbar-collapse').has_content?('问答社区')
    assert find('div.navbar-collapse').has_content?('公共课程')
  end

  test "manager view top and side bar" do
    manager = users(:manager)
    log_in_as(manager)

    assert find('div.navbar-collapse').has_content?('首页'), 'topbar首页不存在'
    assert find('div.navbar-collapse').has_content?('下载'), 'topbar下载不存在'
    assert find('div.navbar-collapse').has_content?('帮助'), 'topbar帮助不存在'

    assert find('ul.menu').has_content?('专属课程'), 'sidebar专属课程不存在'

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
