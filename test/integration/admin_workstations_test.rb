class WorkstationCreateTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @admin  = users(:admin)
    @manager = users(:manager)
    log_in_as(@admin)
  end

  def teardown
    new_logout_as(@admin)
    Capybara.use_default_driver
  end

  test "visit workstation fund" do
    workstation_one = workstations(:workstation_one)
    visit admins_workstation_path(workstation_one)
    assert page.has_link?('资金信息')
    click_on '资金信息'
    assert page.has_content?('账户总金额')
    assert page.has_content?('可提现金额')
  end

  test "visit workstation statistics" do
    workstation_one = workstations(:workstation_one)
    visit statistics_admins_workstation_path(workstation_one)
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
end
