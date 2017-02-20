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
    end

    def teardown
      new_logout_as(@admin)
      Capybara.use_default_driver
    end

    test 'admin pass audit withdraw test' do
      click_link '提现审核'
      @teacher = users(:teacher_balance)

      assert_difference "@teacher.cash_account.reload.balance.to_f", -200 do
        accept_prompt(with: "确认") do
          click_link '通过', match: :first
        end
        sleep 2
      end
      click_link '已审核'
      assert page.has_content?('通过')
    end

    test 'weixin_order test' do
      sleep 2
      assert Payment::WeixinTransfer.last.amount == 200
      Payment::WeixinTransfer.last.remote_transfer
      assert Payment::WeixinTransfer.last.failed?
    end

    test 'admin unpass audit withdraw test' do
      click_link '提现审核'
      @teacher = users(:teacher_balance)
      balance = @teacher.cash_account.balance
      accept_prompt(with: "确认") do
        click_link '驳回', match: :first
      end
      @teacher.reload
      click_link '已审核'
      assert page.has_content?('驳回')
      assert @teacher.cash_account.balance == balance
    end
  end
end
