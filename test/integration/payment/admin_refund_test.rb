require 'test_helper'

module Payment
  class AdminRefundTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @admin = users(:admin)
      new_log2_in_as(@admin)
      visit get_home_url(@admin)
    end

    def teardown
      new_logout_as(@admin)
      Capybara.use_default_driver
    end

    test 'admin pass audit refund test' do
      click_link '退款审核'

      @refund = payment_transactions(:interactive_course_refund_1)
      @teacher1 = @refund.product.teachers.first
      @teacher2 = @refund.product.teachers.second

      assert_difference "@teacher1.reload.notifications.count", 1, "退款没有通知老师1" do
        assert_difference "@teacher2.reload.notifications.count", 1, "退款没有通知老师2" do
          accept_prompt(with: '确认') do
            find(:xpath, "//a[@href=\"#{pass_admins_refund_path(@refund)}\"]").click
          end
          sleep(1)
        end
      end
      assert @refund.product.reload.refunded?, "一对一退款以后没有正常结束"
    end
  end
end
