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
    visit station_workstation_path(workstation_one)
    assert page.has_link?('资金信息')
    click_on '资金信息'
    assert page.has_content?('账户总金额')
    assert page.has_content?('可提现金额')
  end

  test "visit workstation statistics" do
    workstation_one = workstations(:workstation_one)
    visit statistics_station_workstation_path(workstation_one)
    assert page.has_link?('销售额统计')
    assert page.has_link?('售出记录')
    assert page.has_link?('退款记录')
    assert page.has_content?('销售总额')
    assert page.has_select?('statistics_days')

    select('近2月', from: 'statistics_days')

    click_on '退款记录'
    assert page.has_content?('退款金额')

    click_on '售出记录'
    assert page.has_content?('优惠价格')
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

  test "visit workstation workstation_withdraws" do
    binding.pry
    visit admins_workstation_withdraws_path
    assert page.has_link?('工作站提现审核')
    assert page.has_link?('已审核')
    assert page.has_link?('未审核')
    assert page.has_content?('操作')
    click_on '已审核'
    assert page.has_content?('审核结果')
  end
end
