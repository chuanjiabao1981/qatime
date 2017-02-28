require 'test_helper'

module LiveStudio
  class ManagerCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager_zhuji)
      log_in_as(@manager)
    end

    def teardown
      new_logout_as(@manager)
      Capybara.use_default_driver
    end

    test "manager view course list" do
      click_on "辅导班"
      assert page.has_content?('招生中'), "全部列表没有显示招生中辅导班"
      assert page.has_link?('辅导班列表')
      assert page.has_link?('经销记录')

      click_on "经销记录"
      assert page.has_content?('经销分成')
      assert page.has_content?('招生购买')
      assert page.has_select?('select_workstation_id')
      assert page.has_select?('sell_percentage_range', with_options: %w[5%以内 5%-10% 10%])
      assert page.has_select?('subject')
      assert page.has_select?('grade')
      assert page.has_select?('status', with_options: %w[招生中 开课中])

      click_on "辅导班列表"
      assert page.has_content?('经销分成')
      assert page.has_content?('二维码')
      assert page.has_button?('生成'), "没有二维码生成按钮"
      assert page.has_select?('select_workstation_id')
      assert page.has_select?('sell_percentage_range', with_options: %w[5%以内 5%-10% 10%])
      assert page.has_select?('subject')
      assert page.has_select?('grade')
      assert page.has_select?('status', with_options: %w[招生中 开课中])

      page.first(:css, 'input.send_qa_code').click
      assert page.has_selector?('img'), "没有生成二维码图片"
    end
  end
end
