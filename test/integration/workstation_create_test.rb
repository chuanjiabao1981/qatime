class WorkstationCreateTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @admin  = users(:admin)
    log_in_as(@admin)
  end

  def teardown
    #@headless.destroy
    logout_as(@admin)
    # visit get_home_url(@manager)
    # click_on '退出'
    Capybara.use_default_driver
  end

  test "workstation create" do
    visit new_admins_workstation_path
    fill_in :workstation_name, with: '测试工作站'
    fill_in :workstation_address,with: '工作站地址'
    fill_in :workstation_tel,with: '12345678'
    fill_in :workstation_email,with: '12345678@qatime.cn'

    select '阳泉', from: :s_city
    select 'manager', from: :s_manager

    assert_difference 'Workstation.count',1 do
      click_on '新增工作站'
    end
  end
end