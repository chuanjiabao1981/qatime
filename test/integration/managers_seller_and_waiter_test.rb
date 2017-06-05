require 'test_helper'

class ManagersSellerAndWaiterTest < ActionDispatch::IntegrationTest
  self.use_transactional_tests = true

  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @manager = users(:manager)
    new_log_in_as(@manager)
  end

  def teardown
    new_logout_as(@manager)
    Capybara.use_default_driver
  end

  test "manager create and edit seller" do
    workstation = @manager.workstations.first
    click_on "员工管理"
    assert page.has_link? '销售管理'
    assert page.has_link? '客服管理'
    assert page.has_link? '新增人员'
    click_on '新增人员'
    fill_in(:seller_name, with: '优秀销售员')
    fill_in(:seller_email, with: 'best_seller@seller.cn')
    fill_in(:seller_password, with: '123456')
    fill_in(:seller_password_confirmation, with: '123456')
    fill_in(:seller_login_mobile, with: '15811111111')
    assert_difference '@manager.sellers.count', 1 do
      click_on '保存'
    end

    seller = @manager.sellers.last
    find_link("编辑", href: main_app.edit_station_workstation_seller_path(workstation, seller)).click
    fill_in(:seller_name, with: '更优秀销售员')
    click_on('保存')
    assert_equal('更优秀销售员', seller.reload.name, '销售更新失败')
  end

  test "validate seller password confirmation" do
    click_on "员工管理"
    click_on '新增人员'
    assert_no_difference '@manager.sellers.count', '密码确认验证失效' do
      fill_in(:seller_name, with: '优秀销售员')
      fill_in(:seller_email, with: 'best_seller@seller.cn')
      fill_in(:seller_password, with: '123456')
      fill_in(:seller_password_confirmation, with: '1234567')
      fill_in(:seller_login_mobile, with: '15811111112')
      click_on '保存'
    end
  end

  test "manager create and edit waiter" do
    workstation = @manager.workstations.first
    click_on "员工管理"
    click_on '客服管理'
    click_on '新增人员'
    assert_difference '@manager.waiters.count', 1 do
      fill_in(:waiter_name, with: '优秀客服')
      fill_in(:waiter_email, with: 'best_waiter@waiter.cn')
      fill_in(:waiter_password, with: '123456')
      fill_in(:waiter_password_confirmation, with: '123456')
      fill_in(:waiter_login_mobile, with: '15811111113')
      click_on '保存'
    end

    waiter = @manager.waiters.last
    find_link("编辑", href: main_app.edit_station_workstation_waiter_path(workstation, waiter)).click
    fill_in(:waiter_name, with: '更优秀客服')
    click_on('保存')
    assert_equal('更优秀客服', waiter.reload.name, '客服更新失败')
  end

  test "validate waiter password confirmation" do
    click_on "员工管理"
    click_on '客服管理'
    click_on '新增人员'
    assert_no_difference '@manager.waiters.count', '密码确认验证失效' do
      fill_in(:waiter_name, with: '优秀销售员')
      fill_in(:waiter_email, with: 'best_waiter@waiter.cn')
      fill_in(:waiter_password, with: '123456')
      fill_in(:waiter_password_confirmation, with: '1234567')
      fill_in(:waiter_login_mobile, with: '15811111114')
      click_on '保存'
    end
  end
end
