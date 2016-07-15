require 'test_helper'

module LiveStudio
  class MsgsChatTeamTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @teacher = users(:teacher_with_chat_account)
      @student = users(:student_tally)
      @teacher_account = @teacher.chat_account
      @student_account = @student.chat_account

      @course = live_studio_courses(:course_with_junior_teacher)
      @channel = live_studio_channels(:three)

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
        visit chat.live_studio_course_teams_finish_path(@course)
        @course.reload
        visit live_studio.play_course_path(@course)

        fill_in "message-area", with: "同学们，大家好呀"
        click_on "发送"
        sleep(30)

        page.has_content? "同学们，大家好呀"
      end

      Capybara.using_session("teacher") do
        logout_as(@student)
      end
    end
  end
end
