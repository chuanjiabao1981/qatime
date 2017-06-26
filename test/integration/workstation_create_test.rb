require 'test_helper'

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

  test "workstation create with coupon" do
    visit new_admins_workstation_path
    fill_in :workstation_name, with: '测试工作站'
    fill_in :workstation_coupon_attributes_code, with: '2222'
    select '阳泉', from: :s_city
    find(:css, '#is_default').set(true)
    select 'manager', from: :s_manager
    fill_in :workstation_address, with: '工作站地址'
    fill_in :workstation_tel, with: '12345678'
    fill_in :workstation_qq, with: '12345678'
    fill_in :workstation_email, with: '12345678@qatime.cn'
    fill_in :workstation_join_price, with: 10000.33
    fill_in :workstation_caution_money, with: 1000.22
    fill_in :workstation_platform_percentage, with: 8
    fill_in :workstation_service_price, with: 10
    fill_in "dateinfo", with: '2017-03-07'
    fill_in "dateinfo-1", with: '2017-03-20'

    assert_difference 'Workstation.count',1 do
      assert_difference 'Payment::Coupon.count', 1 do
        click_on '保存'
        sleep 1
      end
    end
    assert Workstation.last.is_default_of_city

    coupon_one = payment_coupons(:coupon_one)
    visit new_admins_workstation_path
    fill_in :workstation_name, with: '测试工作站'
    fill_in :workstation_coupon_attributes_code, with: coupon_one.code
    select '阳泉', from: :s_city
    select 'manager', from: :s_manager
    fill_in :workstation_address, with: '工作站地址'
    fill_in :workstation_tel, with: '12345678'
    fill_in :workstation_qq, with: '12345678'
    fill_in :workstation_email, with: '12345678@qatime.cn'
    fill_in :workstation_join_price, with: 10000.33
    fill_in :workstation_caution_money, with: 1000.22
    fill_in :workstation_platform_percentage, with: 8
    fill_in :workstation_service_price, with: 10
    fill_in "dateinfo", with: '2017-03-07'
    fill_in "dateinfo-1", with: '2017-03-20'

    assert_difference 'Payment::Coupon.count', 0 do
      click_on '保存'
      assert page.has_content?('已经被使用'), "优惠码唯一失败"
      sleep 1
    end
  end

  test "visit workstation show" do
    workstation_one = workstations(:workstation_one)
    visit station_workstation_path(workstation_one)
    assert page.has_content?('基本信息')
    assert page.has_content?('合作信息')
    assert page.has_content?('注册编码')
    assert page.has_link?('编辑站点')
    assert page.has_content?(workstation_one.coupon.code), "admin show页面优惠码无法显示"
    click_on '合作信息'
    assert page.has_content?('合作有效期')
    assert page.has_content?('服务费标准')

    new_logout_as(@admin)
    new_log_in_as(@manager)
    visit get_home_url(@manager)
    assert page.has_content?('工作站信息'), "工作站信息页签未显示"
    visit station_workstation_path(workstation_one)
    assert page.has_content?('基本信息')
    assert page.has_content?('合作信息')
    assert page.has_content?('注册编码')
    assert page.has_content?(workstation_one.coupon.code), "manage show页面优惠码无法显示"
    new_logout_as(@manager)
    log_in_as(@admin)
  end

  test "visit workstation index" do
    workstation_one = workstations(:workstation_one)
    visit admins_workstations_path
    assert page.has_link?('新增工作站')
    assert page.has_link?('停止运营合作')
    assert page.has_content?('注册编码')
    assert page.has_content?('运营状态')
    message = accept_prompt(with: '确定切换运营状态么?') do
      click_on '停止运营合作', match: :first
    end
    assert_equal message, "确定切换运营状态么?"
    assert page.has_content?('未运营')
    assert page.has_link?('开启运营合作')
  end
end
