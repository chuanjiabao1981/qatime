require 'test_helper'

class ManagerWorkstationsTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @manager = users(:manager_zhuji)
    new_log_in_as(@manager)
  end

  def teardown
    new_logout_as(@manager)
    Capybara.use_default_driver
  end

  test "visit workstation show" do
    workstation = workstations(:workstation_zhuji)
    visit station_workstation_path(workstation)
    assert page.has_link?('站点信息')
    assert page.has_link?('资金信息')
    assert page.has_link?('基本信息')
    assert page.has_link?('合作信息')

    click_on '合作信息'
    assert page.has_content?('已交加盟费')
    assert page.has_content?('服务费标准')

    click_on '资金信息'
    assert page.has_link? '账户金额'
    assert page.has_link? '出账记录'
    assert page.has_link? '入账记录'

    click_on '申请提现'
    fill_in :withdraw_amount, with: 11
    fill_in :withdraw_payee, with: 'test withdraw'
    fill_in :withdraw_captcha_confirmation, with: 1234
    click_on '提交'
    sleep(1)
    assert page.has_content? '申请提现额'
    assert page.has_content? 'test withdraw'

    click_on '出账记录'
    assert page.has_content? 'test withdraw'
    click_on '查看明细', match: :first
    assert page.has_content? '提现金额'
    assert page.has_content? '提现前可提金额'

    click_on '入账记录'
    assert page.has_content?('收入金额')
    assert page.has_content?('收入类型')
  end

end
