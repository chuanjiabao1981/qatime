require 'test_helper'

module LiveStudio
  class LessonEditTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @teacher = users(:teacher_with_chat_account)
      new_log_in_as(@teacher)
    end

    def teardown
      new_logout_as(@teacher)
      Capybara.use_default_driver
    end

    test 'create lesson' do
      course = @teacher.live_studio_courses.init.last
      visit live_studio.edit_teacher_course_path(@teacher, course, index: 'list')
      click_link '新增课程'
      flag = course.lessons.count+1
      fill_in "new_class_date_#{flag}", with: Time.now.strftime('%Y/%m/%d')
      select '09:00', match: :first, from: "new_start_time_#{flag}"
      select '09:30', match: :first, from: "new_end_time_#{flag}"
      fill_in "new_name_#{flag}", with: 'test lesson'
      click_on '保存'
      assert_match '课程已更新', page.text, '没有创建课程'
    end

    test 'start_time > end_time' do
      course = @teacher.live_studio_courses.init.last
      visit live_studio.edit_teacher_course_path(@teacher, course, index: 'list')
      click_link '新增课程'
      flag = course.lessons.count+1
      fill_in "new_class_date_#{flag}", with: Time.now.strftime('%Y/%m/%d')
      select '09:00', match: :first, from: "new_start_time_#{flag}"

      assert_raises Capybara::ElementNotFound,'没有正确捕捉异常' do
        select('09:00', from: "new_end_time_#{flag}")
      end
      select('09:30', from: "new_end_time_#{flag}")
      fill_in "new_name_#{flag}", with: 'test lesson'
      click_on '保存'
      assert_match '课程已更新', page.text, '没有创建课程'
    end
  end
end
