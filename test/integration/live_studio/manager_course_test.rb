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
      logout_as(@manager)
      Capybara.use_default_driver
    end

    test "manager view course list" do
      click_on "辅导班"
      assert page.has_content?('招生中'), "全部列表没有显示招生中辅导班"
    end
  end
end
