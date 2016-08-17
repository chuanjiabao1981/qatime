require 'test_helper'

module Payment
  class TeacherAccountTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @teacher = users(:teacher_tally)

      new_log_in_as(@teacher)
    end

    def teardown
      new_logout_as(@teacher)
      Capybara.use_default_driver
    end


    test 'teacher account total_income test' do
      visit payment.cash_user_path(@teacher)
      assert page.has_content?(@teacher.account.total_income)
    end

    test 'teacher account withdraws test' do
      visit payment.cash_user_path(@teacher)
      assert page.has_content?(@teacher.account.withdraws.last.operator.name)
    end

    test 'teacher account earning_records test' do
      visit payment.cash_user_path(@teacher)
      click_on '收益记录'
      assert page.has_content?('家庭作业批改')
    end

  end
end
