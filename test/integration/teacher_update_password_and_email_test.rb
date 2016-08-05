require 'test_helper'

class TeacherUpdatePasswordAndEmailTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "teacher update password" do
    teacher = users(:teacher_update_password)
    log_in_as(teacher)
    visit info_teacher_path(teacher)
    click_on "安全设置"

    click_on "修改登录密码", match: :first

    fill_in :teacher_current_password, with: 'password'
    fill_in :teacher_password, with: 'pa123456'
    fill_in :teacher_password_confirmation, with: 'pa123456'
    click_on "保存", match: :first
    teacher.reload
    assert_equal(true, teacher.authenticate('pa123456').present?, '更新密码错误')
    new_logout_as(teacher)
  end

  test "teacher update password new password too short" do
    teacher = users(:teacher_one)
    log_in_as(teacher)

    visit info_teacher_path(teacher)
    click_on "安全设置"
    click_on "修改登录密码", match: :first

    fill_in :teacher_current_password, with: 'password'
    fill_in :teacher_password, with: 'pa'
    fill_in :teacher_password_confirmation, with: 'pa'
    click_on "保存", match: :first

    assert page.has_content? "过短（最短为 6 个字符）"

    new_logout_as(teacher)
  end

  test "teacher update email" do
    teacher = users(:update_email_teacher)
    log_in_as(teacher)

    visit info_teacher_path(teacher)
    click_on "安全设置"
    click_on "修改绑定邮箱", match: :first
    click_on "获取验证码", match: :first

    fill_in "email-captcha-input", with: "1234"
    click_on "下一步"

    fill_in "teacher_email", with: "test_teacher1@test.com"
    click_on "获取验证码", match: :first

    fill_in "teacher_captcha_confirmation", with: "1234"

    click_on "绑定邮箱"
    teacher.reload
    assert_equal("test_teacher1@test.com", teacher.email, '更新邮箱错误')
  end
end
