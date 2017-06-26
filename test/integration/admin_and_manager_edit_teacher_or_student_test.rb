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
    visit get_home_url(@admin)
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
    log_in_as(@admin)
    visit get_home_url(@admin)
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
    new_log_in_as(@manager)
    visit get_home_url(@manager)
    click_on '资源管理'
    click_on '老师管理'
    assert !has_content?('修改安全信息'), 'manager没有修改教师信息权限'
    # while !page.has_css?("#teacher_#{teacher.id}") do
    #   click_on "下一页"
    # end
    #
    # find(:css, "#teacher_#{teacher.id}").click
    #
    # fill_in "teacher_password", with: "password002"
    # find(:css, "#submit_password_#{teacher.id}").click
    #
    # fill_in "teacher_email", with: "edit_test_teacher2@teacher.com"
    # find(:css, "#submit_email_#{teacher.id}").click
    #
    # fill_in "teacher_login_mobile", with: "13892940001"
    # find(:css, "#submit_login_mobile_#{teacher.id}").click
    #
    # sleep 1
    # teacher.reload
    #
    # assert_equal(true, teacher.authenticate('password002').present?, '更新密码错误')
    # assert_equal("edit_test_teacher2@teacher.com", teacher.email, '更新邮箱错误')
    # assert_equal("13892940001", teacher.login_mobile, '更新手机号错误')

    new_logout_as(@manager)
  end

  test 'Manager edit student' do
    new_log_in_as(@manager)
    #student = users(:admin_edit_student)
    visit get_home_url(@manager)
    click_on '资源管理'
    click_on '学生管理'
    assert !has_content?('修改安全信息'), 'manager没有修改学生信息权限'

    # while !page.has_css?("#student_#{student.id}") do
    #   click_on "下一页"
    # end
    #
    # find(:css, "#student_#{student.id}").click
    #
    # fill_in "student_password", with: "password002"
    # find(:css, "#submit_password_#{student.id}").click
    #
    # fill_in "student_email", with: "edit_test_student2@student.com"
    # find(:css, "#submit_email_#{student.id}").click
    #
    # fill_in "student_login_mobile", with: "13892940002"
    # find(:css, "#submit_login_mobile_#{student.id}").click
    #
    # fill_in "student_parent_phone", with: "13892940003"
    # find(:css, "#submit_parent_phone_#{student.id}").click
    #
    # sleep 1
    # student.reload
    #
    # assert_equal(true, student.authenticate('password002').present?, '更新密码错误')
    # assert_equal("edit_test_student2@student.com", student.email, '更新邮箱错误')
    # assert_equal("13892940002", student.login_mobile, '更新手机号错误')
    # assert_equal("13892940003", student.parent_phone, '更新家长手机错误')

    new_logout_as(@manager)
  end

  test 'manager can billing' do
    new_log_in_as(@manager)
    visit get_home_url(@manager)
    teacher = users(:teacher_two)
    click_on '资源管理'
    click_on '老师管理'
    visit teacher_path(teacher)
    click_link '财产管理'
    assert page.has_link?('结账')

    accept_prompt(with: '确定结账吗?') do
      click_on '结账', match: :first
    end
    assert page.has_content?('结账进行中')
    new_logout_as(@manager)
  end

  test 'manager cant modify teacher info' do
    new_log_in_as(@manager)
    visit get_home_url(@manager)
    teacher = users(:teacher_two)
    click_on '资源管理'
    click_on '老师管理'
    assert_not page.has_content?('增加讲师')
    assert_not page.has_content?('修改安全信息')
    visit new_teacher_path
    assert page.has_content?('您没有权限进行这个操作!')
    visit admin_edit_teacher_path(teacher)
    assert page.has_content?('您没有权限进行这个操作!')
    new_logout_as(@manager)
  end

  test 'manager cant modify course_library' do
    new_log_in_as(@manager)
    visit get_home_url(@manager)
    teacher = users(:teacher_two)
    click_on '资源管理'
    click_on '老师管理'
    visit teacher_path(teacher)
    click_link '备课中心'
    assert page.has_content?('您没有权限进行这个操作!')
    visit course_library.teacher_syllabuses_path(teacher)
    assert page.has_content?('您没有权限进行这个操作!')
    new_logout_as(@manager)
  end

  test 'manager cant read not belong himself teacher customized_courses' do
    new_log_in_as(@manager)
    visit get_home_url(@manager)
    click_on '资源管理'
    teacher = users(:teacher2)
    click_on '老师管理'
    visit teacher_path(teacher)
    click_on '专属课程'
    customized_course = teacher.customized_courses.where(workstation: @manager.workstations).first
    assert page.has_content?(customized_course.student.name)
    new_logout_as(@manager)
  end

  test 'manager cant read other workstation customized_courses' do
    new_log_in_as(@manager)
    customized_course = customized_courses(:customized_course_other_workstation)
    visit customized_course_path(customized_course)
    assert page.has_content?('您没有权限进行这个操作!')
    assert_not_includes @manager.customized_courses, customized_course
    new_logout_as(@manager)
  end

  test 'manager only read self-customized_courses list' do
    @manager1 = users(:customized_courses_manager)
    new_log_in_as(@manager1)
    visit get_home_url(@manager)
    click_on '课程管理'
    click_on '专属课程'
    assert_equal all('a', text: '高中-数学').count, 2, '只能看见两个专属课程'
    new_logout_as(@manager1)
  end

  test 'manager cant read not belong himself student customized_courses' do
    new_log_in_as(@manager)
    visit get_home_url(@manager)
    student = users(:student1)
    click_on '资源管理'
    click_on '学生管理'
    visit student_path(student)
    click_on '专属课程'
    customized_course = student.customized_courses.where(workstation: @manager.workstations).first
    assert page.has_content?("#{customized_course.category}-#{customized_course.subject}")
    assert page.has_content?(customized_course.student.name)
    visit new_student_path
    assert page.has_content?('您没有权限进行这个操作!')
    new_logout_as(@manager)
  end

  test 'manager manage school' do
    new_log_in_as(@manager)
    visit get_home_url(@manager)
    click_on '资源管理'
    click_on '学校管理'
    school = schools(:school4)
    assert_not_equal school.city, @manager.city
    assert_not page.has_content?(school.name)
    visit edit_school_path(school)
    assert page.has_content?('您没有权限进行这个操作!')
    new_logout_as(@manager)
  end
end
