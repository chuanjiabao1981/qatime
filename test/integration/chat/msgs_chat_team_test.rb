require 'test_helper'

module Chat
  class MsgsChatTeamTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @teacher = users(:teacher_with_chat_account)
      @student = users(:student_tally)
      @course = live_studio_courses(:course_with_junior_teacher)

      LiveService::ChatAccountFromUser.new(@teacher).instance_account(true)
      LiveService::ChatAccountFromUser.new(@student).instance_account(true)
    end

    def teardown
      Capybara.use_default_driver
    end

    test "student chat in team" do
      Capybara.using_session("teacher") do
        log_in_as(@teacher)
        @course.reload
        visit chat.finish_live_studio_course_teams_path(@course)
        @course.reload
        visit live_studio.play_course_path(@course)

        fill_in "message-area", with: "同学们，大家好呀"
        click_on "发送"
        sleep 5
        assert page.has_content?("同学们，大家好呀"), "消息发送失败"
        assert_equal "2", page.find("#team-online-count").text, "在线人数显示错误"
      end

      Capybara.using_session("student") do
        log_in_as(@student)

        visit live_studio.play_course_path(@course)

        sleep 5
        assert page.has_content?("同学们，大家好呀"), "消息接收失败"

        fill_in "message-area", with: "大家好呀"
        click_on "发送"

        assert page.has_content?("大家好呀"), "消息发送失败"
        assert_equal "2", page.find("#team-online-count").text, "在线人数显示错误"
      end

      Capybara.using_session("student") do
        new_logout_as(@student, true)
      end
      Capybara.using_session("teacher") do
        new_logout_as(@teacher, true)
      end
    end
  end
end
