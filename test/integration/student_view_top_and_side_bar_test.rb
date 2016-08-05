require 'test_helper'

class StudentViewTopAndSideBarTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome

    @student = users(:student1)
    log_in_as(@student)
  end

  def teardown
    new_logout_as(@student)
    Capybara.use_default_driver
  end

  test "student view top bar" do
    visit info_student_path(@student)
    assert page.has_content?('首页'), 'topbar首页不存在'
    assert page.has_content?('公开课程'), 'topbar公开课程不存在'
    assert page.has_content?('专属课程'), 'topbar专属课程不存在'
    assert page.has_content?('问答社区'), 'topbar问答社区不存在'
    assert page.has_content?('辅导班'), 'topbar辅导班不存在'
    assert page.has_content?('下载'), 'topbar下载不存在'
    assert page.has_content?('常见问题'), 'topbar常见问题不存在'
  end

  test "student view side bar" do
    visit info_student_path(@student)
    assert page.has_content?('用户设置'), 'sidebar用户设置不存在'
    assert page.has_content?('我的订单'), 'sidebar我的订单不存在'
    assert page.has_content?('我的辅导'), 'sidebar我的辅导不存在'
    assert page.has_content?('我的作业'), 'sidebar我的作业不存在'
    assert page.has_content?('我的老师'), 'sidebar我的老师不存在'
    assert page.has_content?('我的消息'), 'sidebar我的消息不存在'
  end
end
