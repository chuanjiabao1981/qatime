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

      LiveService::ChatAccountFromUser.new(@teacher).instance_account
      LiveService::ChatAccountFromUser.new(@student).instance_account
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

        p Chat::IM.team_query(@course.chat_team.team_id)
        p "----teacher_chat_account=#{@teacher_account.token}"
        p "----student_chat_account=#{@student_account.token}"

        sleep(3)

        fill_in "message-area", with: "同学们，大家好呀"
        click_on "发送"
        sleep(10)

        page.has_content? "同学们，大家好呀"
      end

      Capybara.using_session("student") do
        log_in_as(@student)

        visit live_studio.play_course_path(@course)

        sleep(3)
        page.has_content? "同学们，大家好呀"

        fill_in "message-area", with: "大家好呀"
        click_on "发送"
        sleep(50)

        page.has_content? "大家好呀"
      end

      Capybara.using_session("student") do
        logout_as(@student)
      end
      Capybara.using_session("teacher") do
        logout_as(@teacher)
      end
    end
  end
end
