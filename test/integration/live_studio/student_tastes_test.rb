require 'test_helper'

module LiveStudio
  class StudentTastesTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @student = users(:student_for_tastes)
      new_log_in_as(@student)
      visit get_home_url(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test "student page tastes view" do
      click_on '我的试听'
      assert page.has_content? '我的试听'
      # assert page.has_link? '试听记录'
      assert page.has_link? '直播课'
      assert page.has_link? '视频课'
      student_data = LiveService::StudentLiveDirector.new(@student)
      taste_courses = student_data.tastes_by('courses')
      assert_equal page.all("ul.calendar-info li").size, taste_courses.count
      assert page.has_content? taste_courses.first.name

      find("a[href='/live_studio/students/#{@student.id}/tastes?cate=video_courses']").click
      taste_video_courses = student_data.tastes_by('video_courses')
      assert_equal page.all("ul.calendar-info li").size, taste_video_courses.count
      assert page.has_content? taste_video_courses.first.name

      # click_on '试听记录'
      # taste_records = student_data.taste_records
      # assert_equal page.all("ul.calendar-info li").size, taste_records.count
    end

  end
end
