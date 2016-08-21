require 'test_helper'

class AdminEditTeacherOrStudentTest < ActionDispatch::IntegrationTest
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

  test 'Admin edit teacher' do
    teacher = users(:teacher_one)
    click_on '教师'

    find(:css, "#teacher_#{teacher.id}").click

    fill_in "teacher_password", with: "password001"
    find(:css, "#submit_password_#{teacher.id}").click

    fill_in "teacher_email", with: "edit_test_teacher@teacher.com"
    find(:css, "#submit_email_#{teacher.id}").click

    fill_in "teacher_login_mobile", with: "13892920001"
    find(:css, "#submit_login_mobile_#{teacher.id}").click
    teacher.reload
    assert_equal(true, teacher.authenticate('password001').present?, '更新密码错误')
    assert_equal("edit_test_teacher@teacher.com", teacher.email, '更新邮箱错误')
    assert_equal("13892920001", teacher.login_mobile, '更新手机号错误')
  end

  test 'Admin edit student' do
    student = users(:student1)
    click_on '学生'

    find(:css, "#student_#{student.id}").click

    fill_in "student_password", with: "password001"
    find(:css, "#submit_password_#{student.id}").click

    fill_in "student_email", with: "edit_test_student@student.com"
    find(:css, "#submit_email_#{student.id}").click

    fill_in "student_login_mobile", with: "13892920002"
    find(:css, "#submit_login_mobile_#{student.id}").click

    fill_in "student_parent_phone", with: "13892920003"
    find(:css, "#submit_parent_phone_#{student.id}").click

    student.reload
    assert_equal(true, student.authenticate('password001').present?, '更新密码错误')
    assert_equal("edit_test_student@student.com", student.email, '更新邮箱错误')
    assert_equal("13892920002", student.login_mobile, '更新手机号错误')
    assert_equal("13892920003", student.parent_phone, '更新家长手机错误')
  end

end
