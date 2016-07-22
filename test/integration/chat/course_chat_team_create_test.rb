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
      accept_alert do
        click_on("开始招生")
      end
      assert page.has_content?('招生中'), "开始招生失败"
      @course.reload
      assert @course.preview?, "开始招生后，辅导班状态不正确"
      assert_not_nil @course.chat_team
      logout_as(@seller)
    end

    test "manager publish course instance team" do
      log_in_as(@manager)
      @course = live_studio_courses(:course_without_chat_team)
      visit live_studio.manager_course_path(@manager, @course)
      accept_alert do
        click_on("开始招生")
      end
      assert page.has_content?('招生中'), "开始招生失败"
      @course.reload
      assert @course.preview?, "开始招生后，辅导班状态不正确"
      assert_not_nil @course.chat_team
      assert_not_nil @course.teacher.chat_account
      logout_as(@manager)
    end

    test "instance team when teacher has no chat account" do
    end
  end
end
