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
    new_logout_as(teacher)
  end

  test "teacher find password by login_mobile" do
    teacher = users(:find_password_teacher)
    new_log_in_as(teacher)

    visit info_teacher_path(teacher)
    click_on "安全设置"
    click_on "修改登录密码", match: :first
    click_on "找回密码", match: :first

    click_on "获取校验码", match: :first

    fill_in "user_captcha_confirmation", with: "1234"

    fill_in :user_password, with: 'pa123456'
    fill_in :user_password_confirmation, with: 'pa123456'

    click_on "提交"

    assert page.has_content?('更新成功'), '没有找回密码'
    new_logout_as(teacher)
  end

  test "teacher update login mobile" do
    teacher = users(:chang_login_mobile_teacher)
    new_log_in_as(teacher)

    visit info_teacher_path(teacher)
    click_on "安全设置"
    click_on "修改绑定手机", match: :first
    click_on "获取验证码", match: :first

    fill_in "login_mobile-captcha-input", with: "1234"
    click_on "下一步"

    fill_in "teacher_login_mobile", with: "13800000011"
    click_on "获取验证码", match: :first

    fill_in "teacher_captcha_confirmation", with: "1234"

    click_on "绑定手机"
    teacher.reload
    assert_equal("13800000011", teacher.login_mobile, '更新手机错误')
    new_logout_as(teacher)
  end

  test "teacher update login mobile when not bind login mobile" do
    teacher = users(:chang_login_mobile_teacher2)
    new_log_in_as(teacher)
    visit info_teacher_path(teacher)
    click_on "安全设置"

    assert page.has_content?('未设置'), '还未绑定手机显示错误'

    click_on "修改绑定邮箱", match: :first
    assert page.has_content?('请先绑定手机号'), '请先绑定手机号显示错误'

    click_on "修改绑定手机", match: :first

    fill_in "teacher_login_mobile", with: "13892910001"
    click_on "获取验证码", match: :first
    fill_in "teacher_captcha_confirmation", with: "1234"
    click_on "绑定手机"
    teacher.reload

    assert_equal("13892910001", teacher.login_mobile, '更新手机错误')
    assert !page.has_content?('还未绑定手机'), '更新手机错误'
    new_logout_as(teacher)
  end

  test "teacher update email when not bind email" do
    teacher = users(:chang_email_teacher1)
    new_log2_in_as(teacher)
    visit info_teacher_path(teacher)
    click_on "安全设置"

    assert page.has_content?('未设置'), '还未绑定邮箱显示错误'
    click_on "修改绑定邮箱", match: :first

    click_on "获取验证码", match: :first

    fill_in "email-captcha-input", with: "1234"
    click_on "下一步"

    fill_in "teacher_email", with: "update_email@teacher.com"
    click_on "获取验证码", match: :first

    fill_in "teacher_captcha_confirmation", with: "1234"
    click_on "绑定邮箱"
    teacher.reload

    assert_equal("update_email@teacher.com", teacher.email, '更新邮箱错误')
    assert !page.has_content?('还未绑定邮箱'), '更新邮箱错误'

    new_logout_as(teacher)
  end
end
