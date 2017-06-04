require 'test_helper'

module Payment
  class SalePlansTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
    end

    def teardown
      new_logout_as(@user) if @user
      Capybara.use_default_driver
    end

    test 'manager sale tasks' do
      @user = users(:manager_zhuji)
      new_log_in_as(@user)
      click_on '首页'
      click_on '考核记录'
      assert page.has_content?("通过")
      assert page.has_content?("未通过")
      all(".view-msg").first.click
    end

    test 'admin create sale tasks' do
      @user = users(:admin)
      new_log_in_as(@user)
      click_on '工作站'
      click_on '诸暨工作站'
      click_on '首页'
      click_on '考核记录'
      click_on '新增'
      fill_in 'sale_task_period', with: 1
      fill_in 'sale_task_target_balance', with: 100_000
      assert page.has_content?('预计平台最低收益: 20000 元')
      assert_difference "Payment::SaleTask.count", 1, "考核创建失败" do
        click_on '新增考核'
      end

      click_on '新增'
      find('#sale_task_started_at').click
      find('#sale_task_started_at').click
      find('.jedatetodaymonth').click
      fill_in 'sale_task_period', with: 3
      fill_in 'sale_task_target_balance', with: -10_000
      click_on '新增考核'
      assert page.has_content?('必须大于或等于 0')
      assert page.has_content?('考核时间冲突')
    end
  end
end
