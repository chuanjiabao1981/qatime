require 'test_helper'

module Payment
  class StudentAccountTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = users(:student1)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test 'student account deposits test' do
      visit payment.cash_user_path(@student)
      click_on '充值记录'
    end

    test 'student account consumption_records test' do
      visit payment.cash_user_path(@student)
      click_on '消费记录'
    end

    test 'student account withdraw test' do
      visit payment.cash_user_path(@student)
      click_on '提现记录'
    end

    test 'student account refund test' do
      visit payment.cash_user_path(@student)
      click_on '退款记录'
    end
  end
end
