require 'test_helper'

module Payment
  class AdminWithdrawRemitsTest < ActionDispatch::IntegrationTest

    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @admin = users(:admin)
      new_log2_in_as(@admin)
    end

    def teardown
      new_logout_as(@admin)
      Capybara.use_default_driver
    end

    test 'admin unpass audit withdraw test' do
      visit payment.withdraw_remits_path
      assert page.has_link?('工作站转款')
      assert page.has_link?('待转款')
      assert page.has_link?('已转款')
      assert page.has_content?('提现金额')
      assert page.has_content?('审核通过时间')
      click_on '已转款'

    end
  end
end
