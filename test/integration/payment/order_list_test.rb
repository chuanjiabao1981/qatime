require 'test_helper'

module Payment
  class StudentAccountTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = users(:student_with_order2)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test 'student visit orders list' do
      click_on '我的订单'
      assert page.has_content? '我的订单'
      click_on '待付款', match: :first
      assert page.has_link? '取消订单'
      assert page.has_link? '立即付款'
      assert page.has_link? '查看详情'
      click_on '已付款', match: :first
      assert page.has_link? '申请退款'
      assert page.has_link? '查看详情'
      click_on '已取消', match: :first
      assert page.has_link? '重新购买'
      assert page.has_link? '查看详情'

      visit payment.user_orders_path(@student)
      click_on '查看详情', match: :first
      assert page.has_content? '授课类型'
      assert page.has_content? '订单编号'
      assert page.has_content? '支付方式'
      assert page.has_link? '取消订单'
      assert page.has_link? '立即付款'
    end
  end
end
