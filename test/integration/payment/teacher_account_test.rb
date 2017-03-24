require 'test_helper'

module Payment
  class TeacherAccountTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @teacher = users(:teacher_tally)
      new_log2_in_as(@teacher)
    end

    def teardown
      new_logout_as(@teacher)
      Capybara.use_default_driver
    end

    test 'teacher account total_income test' do
      visit payment.cash_user_path(@teacher)
      assert page.has_content?(@teacher.cash_account!.total_income)
    end

    test 'teacher account earning_records test' do
      visit payment.cash_user_path(@teacher)
      click_on '收入记录'
      assert page.has_content?('家庭作业批改')
    end

    test 'teacher withdraw operator test' do
      visit payment.cash_user_path(@teacher)
      withdraw_count = Payment::Withdraw.count
      click_link '提现'
      fill_in 'withdraw_amount', with: 1000
      choose 'withdraw_pay_type_bank'
      fill_in 'payment_password', with: '111111'
      fill_in 'bank_account', with: 'test'
      fill_in 'bank_name', with: 'test'
      assert_difference "@teacher.cash_account.reload.balance.to_f", -1000, "提现未扣款" do
        click_on '提现申请'
        sleep(2)
      end
      assert page.has_content?('交易信息')
      assert Payment::Withdraw.count == withdraw_count+1
      click_link '提现记录'
      assert page.has_content?(Payment::Withdraw.last.transaction_no)
    end
  end
end
