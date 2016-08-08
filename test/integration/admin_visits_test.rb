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
    click_on  "#{@teacher.name}[昵称:#{@teacher.nick_name}]"
    click_on '我的辅导班', match: :first
    # visit live_studio.teacher_course_path(@teacher,@course)
    # click_on @course.name
    visit chat.finish_live_studio_course_teams_path(@course)
    visit live_studio.edit_teacher_course_path(@teacher, @course)
    click_on '创建课程', match: :first
    fill_in :lesson_name, with: 'test lesson'
    fill_in :lesson_description, with: 'test description'
    select '9:00', from: :lesson_start_time
    select '9:30', from: :lesson_end_time
    # page.find('#lesson_class_date').set(Time.now.strftime('%Y/%m/%d'))
    fill_in :lesson_class_date, with: Time.now.strftime('%Y/%m/%d')
    click_on '新增课程', match: :first
    lesson = LiveStudio::Lesson.last
    assert_equal(@course.lessons.last, lesson, 'Admin 新增课程失败')
    assert_match('课程已创建', page.text, 'Admin 创建跳转错误')
  end

  test 'admin visit student page' do
    @student = users(:student_one_with_course)
    @course = live_studio_courses(:course_preview)
    click_on '学生'
    click_on @student.name
    click_on '我的辅导'
    visit live_studio.student_course_path(@student, @course, index: 'list')
    assert_match(@course.lessons.last.name, page.text, 'Admin 没有找到辅导班课程')
    click_on '辅导班',match: :first
    # assert_match(@course.name,page.text, 'Admin 没有正确访问搜索辅导班页面')
    page.go_back
    # click_on '我的订单'
    visit payment.user_orders_path(@student,user_class: @student.class)
    # assert page.status_code == 200
    assert_match('商品名称', page.text, 'Admin 没有正确访问我的订单页面')
  end

end
