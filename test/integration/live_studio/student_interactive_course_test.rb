require 'test_helper'

module LiveStudio
  # 一对一观看测试
  class StudentInteractiveCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = users(:student_one_with_course)
      @course = live_studio_interactive_courses(:interactive_course_three_2)
      account_result = Typhoeus::Response.new(code: 200, body: { code: 200, info: { accid: 'xxxxx', token: 'thisisatoken' } }.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(account_result)
      team_result = Typhoeus::Response.new(code: 200, body: { code: 200, tid: '1234212x'}.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/team/create.action').and_return(team_result)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test 'student visit replays' do
      visit live_studio.interactive_course_path(@course)

      assert page.has_link?("开始学习")

      new_window = window_opened_by { click_on '开始学习' }
      within_window new_window do
        assert page.has_content? @course.name
        assert page.has_content? @course.current_lesson.name
        assert page.has_content? '基本属性'
        assert page.has_content? '执教年龄'
        assert page.has_content? '上课安排'
      end
      new_window.close
    end
  end
end
