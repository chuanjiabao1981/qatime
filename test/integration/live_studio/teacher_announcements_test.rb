require 'test_helper'

module LiveStudio
  class TeacherAnnouncementsTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @teacher = users(:physics_teacher1)
      log_in_as(@teacher)
    end

    def teardown
      new_logout_as(@teacher)
      Capybara.use_default_driver
    end

    test 'teacher course announcements page' do
      course = @teacher.live_studio_courses.teaching.first
      visit live_studio.course_announcements_path(course)
      assert page.has_link? '我的直播课'
      assert page.has_link? '发布新公告'

      assert page.has_content? course.name

      click_on '发布新公告'
      fill_in :announcement_content, with: '测试公告测试公告测试公告测试公告'
      assert_difference 'course.announcements.count', 1 do
        click_on '发布'
        assert page.has_content? '测试公告测试公告测试公告测试公告'
      end
    end
  end
end
