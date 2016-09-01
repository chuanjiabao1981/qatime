require 'test_helper'

module LiveStudio
  class TeacherUpadeCourseLessonsTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
    end

    def teardown
      Capybara.use_default_driver
    end

    test "teacher update a courses for uncompleted" do
      teacher = users(:physics_teacher1)
      log_in_as(teacher)

      course = live_studio_courses(:update_course_by_physics_teacher1)
      lesson = live_studio_lessons(:lesson2_of_update_course)

      visit chat.finish_live_studio_course_teams_path(course)
      visit live_studio.update_class_data_teacher_course_path(teacher, course, index: :list)


      time_begin = "%2i" % [Time.zone.now.hour + 1]
      select "#{time_begin}:00", match: :first, from: "start_time_#{lesson.id}"

      assert_raises Capybara::ElementNotFound,'没有正确捕捉异常' do
        select('09:00', from: "end_time_#{lesson.id}")
      end
      select("#{time_begin}:30", from: "end_time_#{lesson.id}")
      click_on '保存'
      assert_match '课程已更新', page.text, '没有更新课程'

      new_logout_as(teacher)
    end
  end
end
