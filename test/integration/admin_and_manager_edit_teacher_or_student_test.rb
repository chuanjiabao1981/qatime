require 'test_helper'

class AdminAndManagerEditTeacherOrStudentTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @manager = users(:manager)

    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test 'Admin edit teacher' do
    log_in_as(@admin)

    teacher = users(:admin_edit_teacher)
    click_on '教师'

    while !page.has_css?("#teacher_#{teacher.id}") do
      click_on "下一页"
    end

    find(:css, "#teacher_#{teacher.id}").click

    fill_in "teacher_password", with: "password001"
    find(:css, "#submit_password_#{teacher.id}").click

    fill_in "teacher_email", with: "edit_test_teacher2@teacher.com"
    find(:css, "#submit_email_#{teacher.id}").click

    fill_in "teacher_login_mobile", with: "13892930001"
    find(:css, "#submit_login_mobile_#{teacher.id}").click

    sleep 1
    teacher.reload

    assert_equal(true, teacher.authenticate('password001').present?, '更新密码错误')
    assert_equal("edit_test_teacher2@teacher.com", teacher.email, '更新邮箱错误')
    assert_equal("13892930001", teacher.login_mobile, '更新手机号错误')
    logout_as(@admin)
  end

  test 'Admin edit student' do
    new_log_in_as(@admin)

    student = users(:admin_edit_student)
    click_on '学生'

    while !page.has_css?("#student_#{student.id}") do
      click_on "下一页"
    end

    find(:css, "#student_#{student.id}").click

    fill_in "student_password", with: "password001"
    find(:css, "#submit_password_#{student.id}").click

    fill_in "student_email", with: "edit_test_student2@student.com"
    find(:css, "#submit_email_#{student.id}").click

    fill_in "student_login_mobile", with: "13892930002"
    find(:css, "#submit_login_mobile_#{student.id}").click

    fill_in "student_parent_phone", with: "13892930003"
    find(:css, "#submit_parent_phone_#{student.id}").click

    sleep 1
    student.reload

    assert_equal(true, student.authenticate('password001').present?, '更新密码错误')
    assert_equal("edit_test_student2@student.com", student.email, '更新邮箱错误')
    assert_equal("13892930002", student.login_mobile, '更新手机号错误')
    assert_equal("13892930003", student.parent_phone, '更新家长手机错误')

    logout_as(@admin)
  end

  test 'Manager edit teacher' do
    log_in_as(@manager)

    teacher = users(:admin_edit_teacher)
    click_on '教师'

    while !page.has_css?("#teacher_#{teacher.id}") do
      click_on "下一页"
    end

    find(:css, "#teacher_#{teacher.id}").click

    fill_in "teacher_password", with: "password002"
    find(:css, "#submit_password_#{teacher.id}").click

    fill_in "teacher_email", with: "edit_test_teacher2@teacher.com"
    find(:css, "#submit_email_#{teacher.id}").click

    fill_in "teacher_login_mobile", with: "13892940001"
    find(:css, "#submit_login_mobile_#{teacher.id}").click

    sleep 1
    teacher.reload

    assert_equal(true, teacher.authenticate('password002').present?, '更新密码错误')
    assert_equal("edit_test_teacher2@teacher.com", teacher.email, '更新邮箱错误')
    assert_equal("13892940001", teacher.login_mobile, '更新手机号错误')

    logout_as(@manager)
  end

  test 'Manager edit student' do
    log_in_as(@manager)
    student = users(:admin_edit_student)
    click_on '学生'

    while !page.has_css?("#student_#{student.id}") do
      click_on "下一页"
    end

    find(:css, "#student_#{student.id}").click

    fill_in "student_password", with: "password002"
    find(:css, "#submit_password_#{student.id}").click

    fill_in "student_email", with: "edit_test_student2@student.com"
    find(:css, "#submit_email_#{student.id}").click

    fill_in "student_login_mobile", with: "13892940002"
    find(:css, "#submit_login_mobile_#{student.id}").click

    fill_in "student_parent_phone", with: "13892940003"
    find(:css, "#submit_parent_phone_#{student.id}").click

    sleep 1
    student.reload

    assert_equal(true, student.authenticate('password002').present?, '更新密码错误')
    assert_equal("edit_test_student2@student.com", student.email, '更新邮箱错误')
    assert_equal("13892940002", student.login_mobile, '更新手机号错误')
    assert_equal("13892940003", student.parent_phone, '更新家长手机错误')

    logout_as(@manager)
  end

  test 'manager cant billing' do
    log_in_as(@manager)
    teacher = users(:teacher_two)
    click_on '教师'
    click_link teacher.name
    click_link '财产管理'
    assert !page.has_content?('结账')

    visit keep_account_teacher_path(teacher)
    assert page.has_content?('您没有权限进行这个操作!')
  end
end
