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

  test "unsigned password edit" do
    user = users(:find_password_student1)
    visit root_path
    click_on "登录", match: :first
    click_on "找回密码", match: :first

    fill_in :user_login_mobile, with: user.login_mobile
    click_on "获取验证码", match: :first
    fill_in :user_captcha_confirmation, with: "1234"

    fill_in :user_password, with: "pa123456"
    fill_in :user_password_confirmation, with: "pa123456"

    click_on "提交", match: :first
    assert page.has_content?('更新成功'), '没有找回密码'
  end
end
