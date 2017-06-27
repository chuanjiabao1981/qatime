require 'test_helper'

module LiveStudio
  # 管理员视频回放测试
  class StudentCourseReplayTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @course = live_studio_courses(:course_for_replay)
      @student = ::Student.find(users(:student_with_order2).id)
      account_result = Typhoeus::Response.new(code: 200, body: { code: 200, info: { accid: 'xxxxx', token: 'thisisatoken' } }.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(account_result)
      new_log_in_as(@student)
    end

    def teardown
      Capybara.use_default_driver
    end

    test 'student visit replays' do
      visit live_studio.course_path(@course)
      assert page.has_content?("观看回放"), "辅导班详情页没有回放链接"
      visit live_studio.play_course_path(@course)
      assert page.has_content?("观看回放"), "辅导班观看页没有回放链接"
      assert page.has_content?("0次"), "剩余播放次数显示不正确"
      assert page.has_content?("1次"), "剩余播放次数显示不正确"
      assert page.has_content?("2次"), "剩余播放次数显示不正确"
      find(:css, '.nav-right-user').hover if page.has_selector?('div.nav-right-user')
      click_on '退出'
    end
  end
end
