require 'test_helper'
require "database_cleaner"

module LiveStudio
  class VideoCourseShowTest < ActionDispatch::IntegrationTest
    def setup
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = users(:student_balance)
      account_result = Typhoeus::Response.new(code: 200, body: { code: 200, info: { accid: 'xxxxx', token: 'thisisatoken' } }.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(account_result)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as @student
      Capybara.use_default_driver
      DatabaseCleaner.clean
    end

    test 'video course show page' do
      course = live_studio_video_courses(:published_video_course1)
      visit live_studio.video_course_path(course)

      assert page.has_content? course.name
      assert page.has_content? '免费试听'
      assert page.has_content? '报名立减'
      assert page.has_content? '限时打折'
      assert page.has_content? '视频总长'
      assert page.has_link? '立即学习'
      assert page.has_link? '进入试听'
      assert page.has_link? '试听本课时'
      assert page.has_link? '观看本课时'

      message2 = accept_prompt(with: '购买后才能观看') do
        click_on '观看本课时', match: :first
      end

      new_window = window_opened_by { click_on '进入试听' }
      within_window new_window do
        taste_lesson = course.taste_lesson
        assert page.has_content? course.name
        assert page.has_content? taste_lesson.name
        assert page.has_content? '视频时长：'
        assert_equal page.all('.playback-con li').size, course.video_lessons.find_all {|x| x.tastable?}.count
      end
      new_window.close
    end
  end
end
