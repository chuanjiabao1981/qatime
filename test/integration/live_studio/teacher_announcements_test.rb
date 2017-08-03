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

    test 'teacher course show page announcement' do
      course = @teacher.live_studio_courses.teaching.first
      visit live_studio.course_path(course)
      assert page.has_link? '发布公告'
      click_on '发布公告', match: :first
      sleep(1)
      fill_in :announcement_content, with: '测试公告啊测试公告啊测试公告啊'
      assert_difference "LiveStudio::Announcement.count", 1, "发布公告失败" do
        click_on "发布"
      end
    end

    test 'teacher interactive show page announcement' do
      teacher1 = users(:teacher1)
      new_logout_as(@teacher)
      new_log_in_as(teacher1)

      course = teacher1.live_studio_interactive_courses.teaching.first
      visit live_studio.interactive_course_path(course)
      assert page.has_link? '发布公告'
      click_on '发布公告', match: :first
      sleep(1)
      fill_in :announcement_content, with: '测试公告啊测试公告啊测试公告啊'
      assert_difference "LiveStudio::Announcement.count", 1, "发布公告失败" do
        click_on "发布"
      end
      new_logout_as(teacher1)
      new_log_in_as(@teacher)
    end
  end
end
