require 'test_helper'

module LiveStudio
  class CourseCurrentLessonTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = users(:student_tally)
      LiveService::ChatAccountFromUser.new(@student).instance_account(true)
      log_in_as(@student)
    end

    def logout_as(user)
      accept_prompt(with: "是否离开直播页面") do
        visit get_home_url(user)
      end
      click_on '退出'
    end

    def teardown
      logout_as(@student)
      Capybara.use_default_driver
    end

    test "student watch play when current lesson status changed" do
      course = live_studio_courses(:course_with_junior_teacher)
      visit chat.finish_live_studio_course_teams_path(course)
      LiveService::LessonDirector.new(course.current_lesson).lesson_start

      course.reload
      course.current_lesson.reload

      p course
      p course.current_lesson
      p course.current_lesson.status_text
      p LiveStudio::Lesson.find(course.current_lesson.id)

      visit live_studio.play_course_path(course)
      course.reload
      course.current_lesson.reload

      p course
      p course.current_lesson
      p course.current_lesson.status_text

      sleep 10
      # assert page.has_selector?('div#my-video'), "播放器初始化错误"

      LiveService::LessonDirector.new(course.current_lesson).pause_lessons
    end
  end
end
