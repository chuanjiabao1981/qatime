require 'test_helper'

class AdminVisitsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

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
    visit live_studio.student_course_path(@student, @course, index: 'list')

    assert_match(@course.lessons.last.name, page.text, 'Admin 没有找到辅导班课程')
    # click_on '辅导班',match: :first
    assert !find('div.navbar-collapse').has_content?('辅导班'), 'topbar辅导班显示存在'
    # assert_match(@course.name,page.text, 'Admin 没有正确访问搜索辅导班页面')
    # page.go_back
    click_on '我的订单'
    assert_match('待付款', page.text, 'Admin 没有正确访问我的订单页面')
  end
end
