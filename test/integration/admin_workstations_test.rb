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
end
