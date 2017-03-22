require 'test_helper'

class UserLoginPasswdWarningTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test 'student login without payment_password' do
    student = users(:student1)
    log_in_as(student)

    visit home_path
    assert page.has_content? '尚未设置支付密码，请完成设置以保证账户资金安全！'
    assert page.has_link? '立即设置'
    find(:css, "#del_pay_password_warning").click
    assert_not page.has_content? '尚未设置支付密码，请完成设置以保证账户资金安全！'
    visit home_path
    assert_not page.has_content? '尚未设置支付密码，请完成设置以保证账户资金安全！'

    new_logout_as(student)
  end

  test 'teacher login without payment_password' do
    teacher = users(:teacher1)
    log_in_as(teacher)

    visit home_path
    assert page.has_content? '尚未设置支付密码，请完成设置以保证账户资金安全！'
    assert page.has_link? '立即设置'
    find(:css, "#del_pay_password_warning").click
    assert_not page.has_content? '尚未设置支付密码，请完成设置以保证账户资金安全！'
    visit home_path
    assert_not page.has_content? '尚未设置支付密码，请完成设置以保证账户资金安全！'
    new_logout_as(teacher)
  end
end
