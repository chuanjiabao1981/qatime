require 'test_helper'

class ManagerWorkstationsTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @manager = users(:manager)
    log_in_as(@manager)
  end

  def teardown
    new_logout_as(@manager)
    Capybara.use_default_driver
  end

  test "visit workstation fund" do
    workstation_one = workstations(:workstation_one)
    visit station_workstation_path(workstation_one)
    assert page.has_link?('资金信息')
    click_on '资金信息'
    assert page.has_content?('账户总金额')
    assert page.has_content?('可提现金额')
    assert page.has_link?('申请提现')
  end

  test "visit workstation statistics" do
    workstation_one = workstations(:workstation_one)
    visit statistics_station_workstation_path(workstation_one)
    assert page.has_link?('销售统计')
    assert page.has_link?('售出记录')
    assert page.has_link?('退款记录')
    assert page.has_content?('销售总额')
    assert page.has_content?('预计销售总收入')
    assert page.has_select?('statistics_days')

    select('近2月', from: 'statistics_days')

    click_on '退款记录'
    assert page.has_content?('退款金额')
    assert page.has_content?('销售收入减少')

    click_on '售出记录'
    assert page.has_content?('优惠价格')
    assert page.has_content?('销售收入增加')
  end

  test "visit workstation change_records" do
    workstation_one = workstations(:workstation_one)
    visit change_records_station_workstation_path(workstation_one)
    assert page.has_link?('出入账记录')
    assert page.has_link?('出账记录')
    assert page.has_link?('入账记录')
    click_on '出账记录'
    assert page.has_content?('支出金额')
    assert page.has_content?('支出类型')

    click_on '入账记录'
    assert page.has_content?('收入金额')
    assert page.has_content?('收入类型')
  end
end
