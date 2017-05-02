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

  test "student view top and side bar" do
    student = users(:student1)
    log_in_as(student)

    assert find('div.navbar-collapse').has_content?('首页'), 'topbar首页不存在'
    assert find('div.navbar-collapse').has_content?('专属课程'), 'topbar专属课程不存在'
    assert find('div.navbar-collapse').has_content?('公共课程'), 'topbar公共课程不存在'
    assert find('div.navbar-collapse').has_content?('问答社区'), 'topbar问答社区不存在'
    assert find('div.navbar-collapse').has_content?('辅导班'), 'topbar辅导班不存在'
    assert find('div.navbar-collapse').has_content?('下载'), 'topbar下载不存在'
    assert find('div.navbar-collapse').has_content?('帮助'), 'topbar帮助不存在'

    assert find('ul.menu').has_content?('用户设置'), 'sidebar用户设置不存在'
    assert find('ul.menu').has_content?('我的钱包'), 'sidebar我的钱包不存在'
    assert find('ul.menu').has_content?('我的订单'), 'sidebar我的订单不存在'
    assert find('ul.menu').has_content?('消息中心'), 'sidebar消息中心不存在'
    assert find('ul.menu').has_content?('我的直播课'), 'sidebar我的直播课不存在'
    assert find('ul.menu').has_content?('我的作业'), 'sidebar我的作业不存在'
    assert find('ul.menu').has_content?('我的老师'), 'sidebar我的老师不存在'
    assert find('ul.menu').has_content?('专属课程'), 'sidebar专属课程不存在'

    new_logout_as(student)
  end

  test "teacher view top and side bar" do
    teacher = users(:teacher1)
    new_log_in_as(teacher)

    assert find('div.navbar-collapse').has_content?('首页'), 'topbar首页不存在'
    assert find('div.navbar-collapse').has_content?('专属课程'), 'topbar专属课程不存在'
    assert find('div.navbar-collapse').has_content?('公共课程'), 'topbar公共课程不存在'
    assert find('div.navbar-collapse').has_content?('问答社区'), 'topbar问答社区不存在'
    assert find('div.navbar-collapse').has_content?('辅导班'), 'topbar辅导班不存在'
    assert find('div.navbar-collapse').has_content?('下载'), 'topbar下载不存在'
    assert find('div.navbar-collapse').has_content?('帮助'), 'topbar帮助不存在'

    assert find('ul.menu').has_content?('用户设置'), 'sidebar用户设置不存在'
    assert find('ul.menu').has_content?('财产管理'), 'sidebar财产管理不存在'
    assert find('ul.menu').has_content?('消息中心'), 'sidebar消息中心不存在'
    assert find('ul.menu').has_content?('我的直播课'), 'sidebar我的直播课不存在'
    assert find('ul.menu').has_content?('我的课程'), 'sidebar我的课程不存在'
    assert find('ul.menu').has_content?('课程状态'), 'sidebar课程状态不存在'
    assert find('ul.menu').has_content?('作业管理'), 'sidebar作业管理不存在'
    assert find('ul.menu').has_content?('学生管理'), 'sidebar学生管理不存在'
    assert find('ul.menu').has_content?('备课中心'), 'sidebar备课中心不存在'
    assert find('ul.menu').has_content?('专属课程'), 'sidebar专属课程不存在'

    new_logout_as(teacher)
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
