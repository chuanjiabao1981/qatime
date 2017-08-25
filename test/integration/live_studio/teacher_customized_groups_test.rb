require 'test_helper'

module LiveStudio
  # 我的专属课测试
  class TeacherCustomizedGroupTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @teacher = users(:teacher1)
      new_log_in_as(@teacher)
    end

    def teardown
      new_logout_as(@teacher)
      Capybara.use_default_driver
    end

    test "visit teacher customized group page" do
      visit live_studio.teacher_customized_groups_path(@teacher)
      assert page.has_content? '我的专属课'
      assert page.has_link? '全部'
      assert page.has_link? '招生中'
      assert page.has_link? '开课中'
      assert page.has_link? '已结束'
      click_on '招生中'
      assert page.has_content? '发布的专属课1'

      click_on '已结束'
      assert page.has_content? '结束的专属课1'
    end
  end
end
