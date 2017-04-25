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
      find("div.order-taxon-div", text: '待付款').click
      page.has_content? '取消订单'
      page.has_content? '立即付款'
      page.has_content? '查看详情'
      find("div.order-taxon-div", text: '已付款').click
      page.has_content? '查看详情'
      find("div.order-taxon-div", text: '已取消').click
      page.has_content? '重新购买'
      page.has_content? '查看详情'
    end
  end
end
