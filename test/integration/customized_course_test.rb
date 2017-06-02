require 'test_helper'

class CustomizedCourseTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome

    @student = users(:student1)
    @teacher = users(:teacher1)
    @manager = users(:manager)
    @admin = users(:admin)
  end

  def teardown
    Capybara.use_default_driver
  end

  test "student customized_course page" do
    new_log_in_as(@student)
    visit customized_courses_student_path(@student)
    assert page.has_content? '我的专属课程'
    assert page.all('ul.exclusive-box li').size, @student.customized_courses.count

    course1 =  @student.customized_courses.first
    assert page.has_link?(nil, href: customized_course_path(course1))
    new_logout_as(@student)
  end

  test "teacher customized_course page" do
    new_log_in_as(@teacher)
    visit customized_courses_teacher_path(@teacher)
    assert page.has_content? '我的专属课程'
    assert page.all('ul.exclusive-box li').size, @teacher.customized_courses.count

    course1 =  @teacher.customized_courses.first
    assert page.has_link?(course1.student.name, href: customized_course_path(course1))

    click_on '编辑备注', match: :first
    fill_in :desc, with: '备注一下啊'
    click_on '保存'
    assert page.has_content? '备注一下啊'
    assert @teacher.customized_courses.exists?(desc: '备注一下啊')
    new_logout_as(@teacher)
  end

  test "manage admin view customized_course page" do
    new_log_in_as(@manager)
    visit customized_courses_student_path(@student)
    assert page.has_content? '是否计费'

    visit customized_courses_teacher_path(@teacher)
    assert page.has_content? '是否计费'
    new_logout_as(@manager)

    new_log_in_as(@admin)
    visit customized_courses_student_path(@student)
    assert page.has_content? '是否计费'
    assert page.has_content? '老师价格'
    assert page.has_content? '平台价格'

    visit customized_courses_teacher_path(@teacher)
    assert page.has_content? '是否计费'
    assert page.has_content? '老师价格'
    assert page.has_content? '平台价格'
    new_logout_as(@admin)
  end

end
