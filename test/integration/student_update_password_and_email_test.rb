require 'test_helper'

class StudentUpdatePasswordAndEmailTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "student update password" do
    student = users(:student1)
    log_in_as(student)
    visit info_student_path(student)
    click_on "安全设置"

    click_on "修改登录密码", match: :first

    fill_in :student_current_password, with: 'password'
    fill_in :student_password, with: 'pa123456'
    fill_in :student_password_confirmation, with: 'pa123456'
    click_on "保存", match: :first
    student.reload
    assert_equal(true, student.authenticate('pa123456').present?, '更新密码错误')
    new_logout_as(student)
  end

  test "student update password new password too short" do
    student = users(:student_one_with_course)
    log_in_as(student)

    visit info_student_path(student)
    click_on "安全设置"
    click_on "修改登录密码", match: :first

    fill_in :student_current_password, with: 'password'
    fill_in :student_password, with: 'pa'
    fill_in :student_password_confirmation, with: 'pa'
    click_on "保存", match: :first

    assert page.has_content? "过短（最短为 6 个字符）"

    new_logout_as(student)
  end

  test "student update email" do
    student = users(:update_email_student)
    log_in_as(student)

    visit info_student_path(student)
    click_on "安全设置"
    click_on "修改绑定邮箱", match: :first
    click_on "获取验证码", match: :first

    fill_in "email-captcha-input", with: "1234"
    click_on "下一步"

    fill_in "student_email", with: "test1@test.com"
    click_on "获取验证码", match: :first

    fill_in "student_captcha_confirmation", with: "1234"

    click_on "绑定邮箱"
    student.reload
    assert_equal("test1@test.com", student.email, '更新邮箱错误')
  end
end
