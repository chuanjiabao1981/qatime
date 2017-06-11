require 'test_helper'

class AdminVisitsTest < ActionDispatch::IntegrationTest
  def setup
    @admin = Admin.find(users(:admin).id)
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    log_in_as(@admin)
  end

  def teardown
    logout_as(@admin)
    Capybara.use_default_driver
  end

  test 'Admin visit teacher page' do
    @teacher = users(:teacher_one)
    @course = live_studio_courses(:course_preview)
    click_on '教师'
    # visit teacher_path(@teacher)
    click_on "#{@teacher.name}[昵称:#{@teacher.nick_name}]"
    click_on '我的直播课', match: :first
    # visit live_studio.teacher_course_path(@teacher,@course)
    # click_on @course.name
    # visit chat.finish_live_studio_course_teams_path(@course)
    # visit live_studio.edit_teacher_course_path(@teacher, @course)
    # assert_not page.has_content?('创建课程')
  end

  test 'admin visit student page' do
    @student = users(:student_one_with_course)
    @student.create_account
    @course = live_studio_courses(:course_preview)
    click_on '学生'
    click_on @student.name
    click_on '我的直播课'
    click_on '我的一对一'
    click_on '我的视频课'
    click_on '我的订单'
    assert_match('待付款', page.text, 'Admin 没有正确访问我的订单页面')
  end
end
