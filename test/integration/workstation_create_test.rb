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
    #@headless.destroy
    new_logout_as(@admin)
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
      sleep 1
    end
  end

  test "workstation create with coupon" do
    visit new_admins_workstation_path
    fill_in :workstation_name, with: '测试工作站2'
    fill_in :workstation_address,with: '工作站地址2'
    fill_in :workstation_tel,with: '123456782'
    fill_in :workstation_email,with: '123456782@qatime.cn'
    select '阳泉', from: :s_city
    select 'manager', from: :s_manager
    fill_in :workstation_coupon_attributes_code, with: 'code1'

    assert_difference 'Workstation.count',1 do
      assert_difference 'Payment::Coupon.count', 1 do
        click_on '新增工作站'
        sleep 1
      end
    end

    coupon_one = payment_coupons(:coupon_one)
    visit new_admins_workstation_path
    fill_in :workstation_name, with: '测试工作站3'
    fill_in :workstation_address,with: '工作站地址3'
    fill_in :workstation_tel,with: '123456783'
    fill_in :workstation_email,with: '123456783@qatime.cn'
    select '阳泉', from: :s_city
    select 'manager', from: :s_manager
    fill_in :workstation_coupon_attributes_code, with: coupon_one.code

    assert_difference 'Payment::Coupon.count', 0 do
      click_on '新增工作站'
      assert page.has_content?('已经被使用'), "优惠码唯一失败"
      sleep 1
    end
  end

  test "visit station workstation show" do
    workstation_one = workstations(:workstation_one)
    visit station_workstation_path(workstation_one)
    assert page.has_content?('电话')
    assert page.has_content?('邮箱')
    assert page.has_content?(workstation_one.coupon.code), "show页面优惠码无法显示"

    new_logout_as(@admin)
    new_log_in_as(@manager)
    assert page.has_content?('工作站信息'), "工作站信息页签未显示"
    visit station_workstation_path(workstation_one)
    assert page.has_content?('电话')
    assert page.has_content?('邮箱')
    assert page.has_content?(workstation_one.coupon.code), "show页面优惠码无法显示"
    new_logout_as(@manager)
    log_in_as(@admin)
  end


end
