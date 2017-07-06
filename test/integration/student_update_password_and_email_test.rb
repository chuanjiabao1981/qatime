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
    new_log_in_as(student)
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

  test "student update email" do
    student = users(:update_email_student)
    new_log_in_as(student)

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
    new_logout_as(student)
  end

  test "student find password by login_mobile" do
    student = users(:find_password_student2)
    new_log_in_as(student)

    visit info_student_path(student)
    click_on "安全设置"
    click_on "修改登录密码", match: :first
    click_on "找回密码", match: :first

    click_on "获取校验码", match: :first

    fill_in "user_captcha_confirmation", with: "1234"

    fill_in :user_password, with: 'pa123456'
    fill_in :user_password_confirmation, with: 'pa123456'

    click_on "提交"

    assert page.has_content?('更新成功'), '没有找回密码'
    new_logout_as(student)
  end

  test "student update login mobile" do
    student = users(:chang_login_mobile_student1)
    new_log_in_as(student)

    visit info_student_path(student)
    click_on "安全设置"
    click_on "修改绑定手机", match: :first
    click_on "获取验证码", match: :first

    fill_in "login_mobile-captcha-input", with: "1234"
    click_on "下一步"
    fill_in "student_login_mobile", with: "13801011111"
    click_on "获取验证码", match: :first

    fill_in "student_captcha_confirmation", with: "1234"
    click_on "绑定手机"
    student.reload

    assert_equal("13801011111", student.login_mobile, '更新手机错误')
    new_logout_as(student)
  end

  test "student update login mobile when not bind login mobile" do
    student = users(:chang_login_mobile_student2)
    new_log_in_as(student)
    visit info_student_path(student)
    click_on "安全设置"

    assert page.has_content?('未设置'), '还未绑定手机显示错误'

    click_on "修改绑定邮箱", match: :first
    assert page.has_content?('请先绑定手机号'), '请先绑定手机号显示错误'

    click_on "修改绑定手机", match: :first

    fill_in "student_login_mobile", with: "13892900001"
    click_on "获取验证码", match: :first
    fill_in "student_captcha_confirmation", with: "1234"
    click_on "绑定手机"
    student.reload

    assert_equal("13892900001", student.login_mobile, '更新手机错误')
    assert !page.has_content?('还未绑定手机'), '更新手机错误'
    new_logout_as(student)
  end

  test "student update email when not bind email" do
    student = users(:chang_email_student1)
    new_log2_in_as(student)
    visit info_student_path(student)
    click_on "安全设置"

    assert page.has_content?('未设置'), '还未绑定邮箱显示错误'

    click_on "修改绑定邮箱", match: :first
    click_on "获取验证码", match: :first

    fill_in "email-captcha-input", with: "1234"
    click_on "下一步"

    fill_in "student_email", with: "update_email@student.com"
    click_on "获取验证码", match: :first

    fill_in "student_captcha_confirmation", with: "1234"

    click_on "绑定邮箱"
    student.reload

    assert_equal("update_email@student.com", student.email, '更新邮箱错误')
    assert !page.has_content?('还未绑定邮箱'), '更新邮箱错误'

    new_logout_as(student)
  end

  test "student update parent phone when not bind parent phone" do
    student = users(:chang_parent_phone_student1)
    new_log2_in_as(student)
    visit info_student_path(student)
    click_on "安全设置"

    assert page.has_content?('未设置'), '还未绑定家长手机显示错误'

    click_on "修改家长手机", match: :first
    fill_in "student_current_password", with: "password"
    fill_in "student_parent_phone", with: "13892930006"
    click_on "获取验证码"
    fill_in "student_captcha_confirmation", with: "1234"

    click_on "绑定家长手机"
    student.reload

    assert_equal("13892930006", student.parent_phone, '更新家长手机错误')
    assert !page.has_content?('还未绑定家长手机'), '更新家长手机错误'

    new_logout_as(student)
  end
end
