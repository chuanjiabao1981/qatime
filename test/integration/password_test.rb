require 'test_helper'

class PasswordTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test "login_mobile unsigned password edit" do
    user = users(:find_password_student1)
    visit root_path
    click_on "登录", match: :first
    click_on "忘记密码", match: :first

    fill_in :user_login_account, with: user.login_mobile
    click_on "获取校验码", match: :first
    fill_in :user_captcha_confirmation, with: "1234"

    fill_in :user_password, with: "pa123456"
    fill_in :user_password_confirmation, with: "pa123456"

    click_on "提交", match: :first
    assert page.has_content?('更新成功'), '没有找回密码'
  end

  test "email unsigned password edit" do
    user = users(:find_password_student2)
    visit root_path
    click_on "登录", match: :first
    click_on "忘记密码", match: :first

    fill_in :user_login_account, with: user.email
    click_on "获取校验码", match: :first
    fill_in :user_captcha_confirmation, with: "1234"

    fill_in :user_password, with: "pa123456"
    fill_in :user_password_confirmation, with: "pa123456"

    click_on "提交", match: :first
    assert page.has_content?('更新成功'), '没有找回密码'
  end

  test "forget payment password and reset" do
    user = users(:find_password_student2)
    visit new_payment_password_passwords_path
    fill_in :user_login_account, with: user.login_mobile
    click_on "获取校验码", match: :first
    fill_in :user_payment_captcha_confirmation, with: "1234"
    fill_in :user_payment_password, with: "121212"
    fill_in :user_payment_password_confirmation, with: "121212"
    click_on "提交", match: :first
    assert page.has_content?('更新成功'), '手机没有找回支付密码'

    visit new_payment_password_passwords_path
    fill_in :user_login_account, with: user.email
    click_on "获取校验码", match: :first
    fill_in :user_payment_captcha_confirmation, with: "1234"
    fill_in :user_payment_password, with: "131313"
    fill_in :user_payment_password_confirmation, with: "131313"
    click_on "提交", match: :first
    assert page.has_content?('更新成功'), '邮箱没有找回支付密码'
  end
end
