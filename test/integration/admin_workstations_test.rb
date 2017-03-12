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

  test "visit workstation change_records" do
    workstation_one = workstations(:workstation_one)
    visit change_records_admins_workstation_path(workstation_one)
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
