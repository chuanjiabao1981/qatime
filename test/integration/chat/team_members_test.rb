require 'test_helper'

module Chat
  class TeamMembersTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = users(:student_one_with_course)

      @teacher = users(:teacher_with_chat_account)
      @student = users(:student_tally)
      @course = live_studio_courses(:course_with_junior_teacher)
      log_in_as(@student)
      LiveService::ChatAccountFromUser.new(@teacher).instance_account(true)
      LiveService::ChatAccountFromUser.new(@student).instance_account(true)
      visit chat.finish_live_studio_course_teams_path(@course)
      @course.reload
    end

    def teardown
      logout_as(@student)
      Capybara.use_default_driver
    end

    test 'team members' do
      visit chat.members_team_path(@course.chat_team.team_id)
      assert page.has_content?(@student.name)
    end

    test 'team member visit online' do
      visit chat.member_visit_team_path(@course.chat_team.team_id, acc_id: @student.chat_account.accid, token: @student.chat_account.token)
      assert page.find(".online").has_content?(@student.name)
    end

    test 'team member list page' do
      visit live_studio.play_course_path(@course)
      click_on '成员', match: :first
      assert page.has_content?(@student.name)
      assert page.find(".online").has_content?(@student.name)
      accept_alert do
        click_on @student.name, match: :first
      end
    end
  end
end
