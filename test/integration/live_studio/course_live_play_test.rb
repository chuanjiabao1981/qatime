require 'test_helper'

module LiveStudio
  class CourseLivePlayTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = users(:student_tally)
      @course = live_studio_courses(:course_with_junior_teacher)

      account_result = Typhoeus::Response.new(code: 200, body: { code: 200, info: { accid: 'xxxxx', token: 'thisisatoken' } }.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(account_result)

      LiveService::ChatAccountFromUser.new(@student).instance_account(true)
      new_log_in_as(@student)
    end

    def logout_as(user)
      visit get_home_url(user)
      click_on '退出'
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test "student watch play" do
      visit chat.finish_live_studio_course_teams_path(@course)
      @course.reload
      visit live_studio.play_course_path(@course)

      assert page.has_selector?('div#my-video'), "播放器初始化错误"
    end

    test "student get course information with watch play" do
      visit chat.finish_live_studio_course_teams_path(@course)
      @course.reload
      visit live_studio.play_course_path(@course)
      assert page.has_content?(@course.name), '辅导班名称显示不正确'
      # assert page.has_content?('辅导详情'), '辅导详情按钮不存在'
      # assert find(:css, '#live_detail_area').has_content?('辅导概况'), '辅导概况按钮不存在'
      # assert find(:css, '#live_detail_area').has_content?('教师资料'), '教师资料按钮不存在'
      # assert find(:css, '#live_detail_area').has_content?('课程列表'), '课程列表按钮不存在'
      #
      # assert find(:css, '#detail_base_area').has_content?(@course.name), '辅导概况显示不正确'
      #
      # find(:css, '#detail_teacher_btn').click
      # assert find(:css, '#detail_teacher_area').has_content?(@course.teacher.name), '教师资料显示不正确'
      #
      # find(:css, '#detail_course_btn').click
      # assert find(:css, '#detail_course_area').has_content?(@course.lessons.first.name), '课程列表显示不正确'
    end
  end
end
