require 'test_helper'

module Chat
  class HistoryMsgsChatTeamTest < ActionDispatch::IntegrationTest
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

    test "student get histroy chat in team" do
      Capybara.using_session("teacher") do
        new_log_in_as(@teacher)
        @course.reload
        visit chat.finish_live_studio_course_teams_path(@course)
        @course.reload
        visit live_studio.play_course_path(@course)

        sleep(3)
        fill_in "message-area", with: "同学们，大家好呀"
        click_on "发送"
      end

      Capybara.using_session("student") do
        new_log_in_as(@student)
        visit live_studio.play_course_path(@course)

        sleep(3)
        click_on "消息记录"

        page.has_selector?('div#histories')
        assert find(:css, 'div#histories').has_content?('同学们，大家好呀'), "历史消息查看错误"
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
