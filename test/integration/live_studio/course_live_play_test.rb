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

      LiveService::ChatAccountFromUser.new(@student).instance_account(true)
      log_in_as(@student)
    end

    def logout_as(user)
      accept_prompt(with: "是否离开直播页面") do
        visit get_home_url(user)
      end
      click_on '退出系统'
    end

    def teardown
      logout_as(@student)
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

      assert page.has_content?('直播详情'), '直播详情按钮不存在'
      find(:css, '#live_detail_btn').click

      assert find(:css, '#live_detail_area').has_content?('基本信息'), '基本信息按钮不存在'
      assert find(:css, '#live_detail_area').has_content?('老师详情'), '老师详情按钮不存在'
      assert find(:css, '#live_detail_area').has_content?('课程列表'), '课程列表按钮不存在'

      assert find(:css, '#detail_base_area').has_content?(@course.name), '基本信息显示不正确'

      find(:css, '#detail_teacher_btn').click
      assert find(:css, '#detail_teacher_area').has_content?(@course.teacher.name), '教师详情显示不正确'

      find(:css, '#detail_course_btn').click
      assert find(:css, '#detail_course_area').has_content?(@course.lessons.first.name), '课程列表显示不正确'
    end
  end
end
