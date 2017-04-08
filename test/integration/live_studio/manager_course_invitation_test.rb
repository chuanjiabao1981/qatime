require 'test_helper'

module LiveStudio
  class ManagerCourseInvitationTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager)
      new_log_in_as(@manager)
    end

    def teardown
      logout_as(@manager)
      Capybara.use_default_driver
    end

    # test 'visit course invitation page' do
    #   click_on '辅导班'
    #   visit live_studio.station_workstation_course_invitations_path(@manager.workstations.first)
    #   assert page.has_content?('创建新邀请')
    # end
    #
    # test 'create new invitation page success' do
    #   click_on '辅导班'
    #   click_on '开班邀请'
    #   click_on '创建新邀请',match: :first
    #   fill_in :course_invitation_user_mobile, with: '13439338326'
    #   fill_in :course_invitation_teacher_percent, with: '80'
    #   fill_in :course_invitation_expited_day, with: '10'
    #   click_on '立即发送'
    #   assert_match('开班邀请已创建', page.text, 'Course invitation创建失败')
    # end
    #
    # test 'create new invitation page fail' do
    #   click_on '辅导班'
    #   click_on '开班邀请'
    #   click_on '创建新邀请', match: :first
    #   fill_in :course_invitation_user_mobile, with: '11111111111'
    #   fill_in :course_invitation_teacher_percent, with: '101'
    #   fill_in :course_invitation_expited_day, with: 'test'
    #   click_on '立即发送'
    #   assert_match('手机号不存在', page.text, 'Course invitation创建失败')
    #   assert_match('必须小于或等于 85', page.text, 'Course invitation创建失败')
    #   assert_match('不是数字', page.text, 'Course invitation创建失败')
    # end
  end
end
