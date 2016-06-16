require 'test_helper'

class ManagersSellerAndWaiterTest < ActionDispatch::IntegrationTest

  self.use_transactional_fixtures = true

  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @manager            = users(:manager1)
    log_in_as(@manager)
  end

  def teardown
    #@headless.destroy
    logout_as(@manager)
    Capybara.use_default_driver
  end

  test "manager create and edit seller" do
    workstation = @manager.workstations.sample
    assert_difference '@manager.sellers.count', 1 do
      visit new_managers_seller_path
      fill_in(:seller_name, with: '优秀销售员')
      fill_in(:seller_email, with: 'best_seller@seller.cn')
      fill_in(:seller_password, with: '123456')
      fill_in(:seller_password_confirmation, with: '123456')
      fill_in(:waiter_mobile, with: '15811111111')
      select workstation.name, from: 'seller_workstation_id'
      click_on '新增销售'
    end

    seller = @manager.sellers.last
    visit edit_managers_seller_path(seller)
    fill_in(:seller_name, with: '更优秀销售员')
    click_on('更新销售')
    assert_equal('更优秀销售员', seller.reload.name, '销售更新失败')

    # assert_difference '@manager.sellers.count', -1 do
    #   visit managers_sellers_path
    # end
  end


  test "validate seller password confirmation" do
    workstation = @manager.workstations.sample
    assert_no_difference '@manager.sellers.count', '密码确认验证失效' do
      visit new_managers_seller_path
      fill_in(:seller_name, with: '优秀销售员')
      fill_in(:seller_email, with: 'best_seller@seller.cn')
      fill_in(:seller_password, with: '123456')
      fill_in(:seller_password_confirmation, with: '1234567')
      fill_in(:waiter_mobile, with: '15811111111')
      select workstation.name, from: 'seller_workstation_id'
      click_on '新增销售'
    end
  end

  test "manager create and edit waiter" do
    workstation = @manager.workstations.sample
    assert_difference '@manager.waiters.count', 1 do
      visit new_managers_waiter_path
      fill_in(:waiter_name, with: '优秀客服')
      fill_in(:waiter_email, with: 'best_waiter@waiter.cn')
      fill_in(:waiter_password, with: '123456')
      fill_in(:waiter_password_confirmation, with: '123456')
      fill_in(:waiter_mobile, with: '15811111111')
      select workstation.name, from: 'waiter_workstation_id'
      click_on '新增客服'
    end

    waiter = @manager.waiters.last
    visit edit_managers_waiter_path(waiter)
    fill_in(:waiter_name, with: '更优秀客服')
    click_on('更新客服')
    assert_equal('更优秀客服', waiter.reload.name, '客服更新失败')

  end


  test "validate waiter password confirmation" do
    workstation = @manager.workstations.sample
    assert_no_difference '@manager.waiters.count', '密码确认验证失效' do
      visit new_managers_waiter_path
      fill_in(:waiter_name, with: '优秀销售员')
      fill_in(:waiter_email, with: 'best_waiter@waiter.cn')
      fill_in(:waiter_password, with: '123456')
      fill_in(:waiter_password_confirmation, with: '1234567')
      fill_in(:waiter_mobile, with: '15811111111')
      select workstation.name, from: 'waiter_workstation_id'
      click_on '新增客服'
    end
  end
end
