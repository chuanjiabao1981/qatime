require 'test_helper'

module Chat
  class CourseChatTeamTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager)
      @seller = users(:seller)
    end

    def teardown
      Capybara.use_default_driver
    end

    test "seller publish course" do
      log_in_as(@seller)
      @course = live_studio_courses(:course_with_junior_teacher)
      visit live_studio.seller_course_path(@seller, @course)
      assert page.has_no_content?('开始招生'), "销售开始招生权限错误"
      logout_as(@seller)
    end

    test "manager publish course instance team" do
      log_in_as(@manager)
      @course = live_studio_courses(:course_without_chat_team)
      visit live_studio.manager_course_path(@manager, @course)
      assert page.has_no_content?('开始招生'), "管理员开始招生权限错误"
      logout_as(@manager)
    end

    test "instance team when teacher has no chat account" do
    end
  end
end
