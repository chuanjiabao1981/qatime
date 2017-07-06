require 'test_helper'

module Payment
  class AdminWithdrawTest < ActionDispatch::IntegrationTest
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

    test 'admin pass audit withdraw test' do
      click_link '提现审核'
      @teacher = users(:teacher_balance)

      assert_no_difference "@teacher.cash_account.reload.balance.to_f", "提现审核通过后重复扣款" do
        accept_prompt(with: "确认") do
          click_link '通过', match: :first
        end
        sleep 2
      end
      click_link '已审核'
      assert page.has_content?('通过')
    end

    test 'admin unpass audit withdraw test' do
      click_link '提现审核'
      @teacher = users(:teacher_balance)
      assert_difference "@teacher.reload.cash_account.balance.to_f", 200.00, "提现失败金额没有退回" do
        assert_difference "Payment::WithdrawRefundRecord.count", 1, "资金退回记录没有生成" do
          accept_prompt(with: "确认") do
            click_link '驳回', match: :first
          end
          sleep(2)
        end
      end
      click_link '已审核'
      assert page.has_content?('驳回')
    end
  end
end
