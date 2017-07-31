require 'test_helper'

module LiveStudio
  # 我的专属课测试
  class StudentCustomizedGroupTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = users(:student_view_customized_group)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test "visit student customized group page" do
      visit live_studio.student_customized_groups_path(@student)
      assert page.has_content? '我的专属课'
      assert page.has_link? '待开课'
      assert page.has_link? '已开课'
      assert page.has_link? '已结束'
      assert page.has_link? '我的专属课published'
      click_on '已开课'
      assert page.has_link? '我的专属课teaching'

      click_on '已结束'
      assert page.has_link? '我的专属课completed'
    end
  end
end
