require 'test_helper'

module LiveStudio
  class ManagerInteractiveCoursesTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager_zhuji)
      log_in_as(@manager)
    end

    def teardown
      new_logout_as(@manager)
      Capybara.use_default_driver
    end

    test 'manager create interactive_course' do
      visit live_studio.new_interactive_course_path
      assert page.has_content? '一对一课程说明'

      fill_in :interactive_course_name, with: '一对一互动测试'
      find('div[contenteditable]').set('test description')
      select '高一', from: 'interactive_course_grade'
      select '数学', from: 'interactive_course_subject'
      fill_in :interactive_course_objective, with: '课程目标课程目标课程目标课程目标课程目标课程目标课程目'
      fill_in :interactive_course_suit_crowd, with: '课程目标课程目标课程目标课程目标课程目标课程目标课程目标课1'
      fill_in :interactive_course_price, with: '310'
      fill_in :interactive_course_teacher_percentage, with: '90'

      10.times do |index|
        find("#interactive_course_interactive_lessons_attributes_#{index}_teacher_id").find(:xpath, "option[#{rand(2..8)}]").select_option
        find("#interactive_course_interactive_lessons_attributes_#{index}_start_time_hour").find(:xpath, 'option[11]').select_option
        find("#interactive_course_interactive_lessons_attributes_#{index}_start_time_minute").find(:xpath, 'option[8]').select_option
      end

      execute_script("$('#interactive_course_interactive_lessons_attributes_0_class_date').val('#{(Date.today + 1.days).to_s}')")
      execute_script("$('#interactive_course_interactive_lessons_attributes_1_class_date').val('#{(Date.today + 2.days).to_s}')")
      execute_script("$('#interactive_course_interactive_lessons_attributes_2_class_date').val('#{(Date.today + 3.days).to_s}')")
      execute_script("$('#interactive_course_interactive_lessons_attributes_3_class_date').val('#{(Date.today + 4.days).to_s}')")
      execute_script("$('#interactive_course_interactive_lessons_attributes_4_class_date').val('#{(Date.today + 5.days).to_s}')")
      execute_script("$('#interactive_course_interactive_lessons_attributes_5_class_date').val('#{(Date.today + 6.days).to_s}')")
      execute_script("$('#interactive_course_interactive_lessons_attributes_6_class_date').val('#{(Date.today + 7.days).to_s}')")
      execute_script("$('#interactive_course_interactive_lessons_attributes_7_class_date').val('#{(Date.today + 8.days).to_s}')")
      execute_script("$('#interactive_course_interactive_lessons_attributes_8_class_date').val('#{(Date.today + 9.days).to_s}')")
      execute_script("$('#interactive_course_interactive_lessons_attributes_9_class_date').val('#{(Date.today + 10.days).to_s}')")

      assert_difference 'LiveStudio::InteractiveCourse.count', 0, "一对一唯一日期校验失败" do
        assert_difference 'LiveStudio::InteractiveLesson.count', 0, "一对一唯一日期校验失败" do
          execute_script("$('#interactive_course_interactive_lessons_attributes_8_class_date').val('#{(Date.today + 10.days).to_s}')")
          execute_script("$('#interactive_course_interactive_lessons_attributes_9_class_date').val('#{(Date.today + 10.days).to_s}')")
          click_on '发布招生'
          assert page.has_content? '上课时间不能重复'
        end
      end

      execute_script("$('#interactive_course_interactive_lessons_attributes_8_class_date').val('#{(Date.today + 9.days).to_s}')")
      execute_script("$('#interactive_course_interactive_lessons_attributes_9_class_date').val('#{(Date.today + 10.days).to_s}')")
      assert_difference 'LiveStudio::InteractiveCourse.count', 1, "一对一创建失败" do
        assert_difference 'LiveStudio::InteractiveLesson.count', 10, "一对一创建失败" do
          click_on '发布招生'
        end
      end
    end

  end
end
