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
        log_in_as(@teacher)
        @course.reload
        visit chat.finish_live_studio_course_teams_path(@course)
        @course.reload
        visit live_studio.play_course_path(@course)

        sleep(5)
        fill_in "message-area", with: "同学们，大家好呀"
        click_on "发送"
      end

      Capybara.using_session("student") do
        log_in_as(@student)
        visit live_studio.play_course_path(@course)

        sleep(10)
        click_on "历史消息"
        sleep(20)

        page.has_selector?('div#history-area')
        page.find('div#history-area').has_content?('同学们，大家好呀')
      end

      Capybara.using_session("student") do
        logout_as(@student, true)
      end
      Capybara.using_session("teacher") do
        logout_as(@teacher, true)
      end
    end
  end
end
