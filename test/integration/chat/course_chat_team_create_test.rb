require 'test_helper'

module LiveStudio
  class CourseChatTeamTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager)
      log_in_as(@manager)
    end

    def teardown
      logout_as(@manager)
      Capybara.use_default_driver
    end

    test "waiter publish course" do

    end

    test "seller publish course" do

    end

    test "manager publish course instance team" do
      @course = live_studio_courses(:course_without_chat_team)
      visit live_studio.manager_course_path(@manager, @course)
      sleep(10)
      accept_alert do
        click_on("开始招生")
      end
      assert page.has_content?('招生中'), "开始招生失败"
      @course.reload
      assert @course.preview?, "开始招生后，辅导班状态不正确"
      assert_not_nil @course.chat_team
      assert_not_nil @course.teacher.chat_account
    end

    test "instance team when teacher has no chat account" do
    end

  end
end
