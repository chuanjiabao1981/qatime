require 'test_helper'

module LiveStudio
  class ManagerVisitTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager)
      @workstation = @manager.workstations.first
      account_result = Typhoeus::Response.new(code: 200, body: { code: 200, info: { accid: 'xxxxx', token: 'thisisatoken' } }.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(account_result)
      new_log_in_as(@manager)
    end

    def teardown
      new_logout_as(@manager)
      Capybara.use_default_driver
    end

    test 'visit teacher page' do
      @teacher = users(:english_teacher)
      @course = @teacher.live_studio_courses.first
      visit chat.finish_live_studio_course_teams_path(@course)
      visit teacher_path(@teacher)
      click_on '我的直播课'
      visit live_studio.teacher_course_path(@teacher, @course)
      assert_match @course.name, page.text, '没有正确跳转到辅导班详情页'
    end

    test 'visit student page' do
      @student = users(:student_one_with_course)
      @course = live_studio_courses(:course_preview)
      visit student_path(@student)
      click_on '我的直播课'
      visit live_studio.student_course_path(@student, @course)
      assert_match @course.name, page.text, '--'
      page.go_back
      visit live_studio.courses_index_path
      assert_match('测试辅导1班', page.text, '没有正确跳转到辅导班搜索页')
    end

  end
end
