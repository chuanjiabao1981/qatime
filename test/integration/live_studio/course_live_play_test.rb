require 'test_helper'

module LiveStudio
  class CourseLivePlayTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @create_response_body = {
        "code": 200,
        "msg": '',
        "ret": {
          "cid": "bfca60cef2eb464fbf0f05c3fafacef1",
          "ctime": "rtmp://p2e95df8c.live.126.net/live/19419193f30441a",
          "pushUrl": "rtmp://p2e95df8c.live.126.net/live/19419193f3044b",
          "httpPullUrl": "rtmp://p2e95df8c.live.126.net/live/19419193f3044c",
          "hlsPullUrl": "rtmp://p2e95df8c.live.126.net/live/19419193f3044d",
          "rtmpPullUrl": "rtmp://p2e95df8c.live.126.net/live/19419193f3044e"
        }
        }.to_json

      @student = ::Student.find(users(:student_one_with_course).id)
      log_in_as(@student)
    end

    def teardown
      logout_as(@student)
      Capybara.use_default_driver
    end

    test "student watch play" do
      course = live_studio_courses(:course_with_lesson)
      lesson = live_studio_lessons(:lesson_three)

      response = Typhoeus::Response.new(code: 200, body: @create_response_body)
      Typhoeus.stub('https://vcloud.163.com/app/channel/create').and_return(response)

      channel = course.init_channel
      p course.channels
      p channel.name
      p course.channels.first

      visit live_studio.play_course_lesson_path(course, lesson)

      page.has_content? channel.name

    end
  end
end
