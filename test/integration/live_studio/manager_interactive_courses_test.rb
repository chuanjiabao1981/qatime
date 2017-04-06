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

    test 'manager interactive_course index' do
      assert page.has_link? '一对一管理'
      click_on '一对一管理'
      assert page.has_link? '创建新课程'
      # assert_difference 'LiveStudio::InteractiveCourse.count', -1, "一对一删除失败" do
      #   assert_difference 'LiveStudio::InteractiveLesson.count', -10, "一对一课程删除失败" do
      #     accept_prompt(with: '确定删除?') do
      #       click_on '删除', match: :first
      #     end
      #     sleep(3)
      #   end
      # end
    end

    test 'manager create interactive_course' do
      visit live_studio.new_interactive_course_path
      assert page.has_content? '一对一课程说明'
      assert page.has_content? '一对一互动课程-第一课时'
      assert page.has_content? '一对一互动课程-第十课时'

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

    test 'manager interactive_course update_class_date' do
      click_on '一对一管理'
      interactive_course_zhuji = live_studio_interactive_courses(:interactive_course_zhuji)
      visit live_studio.update_class_date_interactive_course_path(interactive_course_zhuji)
      assert page.has_content? '调课'
      assert page.has_content? interactive_course_zhuji.name
      assert_equal 9, page.all(".adjust-list li").size, "调课只能调unstart的课程"

      lessons = interactive_course_zhuji.interactive_lessons.unstart.order(class_date: :asc)
      lesson1, lesson2 = lessons.first, lessons.second

      # 调重复失败
      find("a[data-target='#adjust_edit_#{lesson1.id}']").click
      assert page.has_content? lesson1.teacher.name
      assert page.has_content? lesson1.class_date.to_s
      assert page.has_content? lesson1.start_time
      select 'teacher1', from: 'interactive_course_interactive_lessons_attributes_1_teacher_id'
      execute_script("$('#interactive_course_interactive_lessons_attributes_1_class_date').val('#{lesson2.class_date.to_s}')")
      select '09', from: 'interactive_course_interactive_lessons_attributes_1_start_time_hour'
      select '30', from: 'interactive_course_interactive_lessons_attributes_1_start_time_minute'
      click_on '保存'
      assert page.has_content? '<修改后> teacher1'
      assert page.has_content? "<修改后> #{lesson2.class_date.to_s} 09:30-10:15"
      click_on '保存调课'
      assert page.has_content? '上课时间不能重复'

      find("a[data-target='#adjust_edit_#{lesson1.id}']").click
      execute_script("$('#interactive_course_interactive_lessons_attributes_1_class_date').val('#{(lesson1.class_date + 9.days).to_s}')")
      click_on '保存'
      find("a[data-target='#adjust_edit_#{lesson2.id}']").click
      execute_script("$('#interactive_course_interactive_lessons_attributes_2_class_date').val('#{(lesson2.class_date + 9.days).to_s}')")
      click_on '保存'
      click_on '保存调课'
      sleep(3)

      old_class_date1 = lesson1.class_date
      old_class_date2 = lesson2.class_date
      assert_equal lesson1.reload.class_date, old_class_date1 + 9.days, "调课不成功"
      assert_equal lesson2.reload.class_date, old_class_date2 + 9.days, "调课不成功"
    end

    test 'manager interactive_course preview' do
      visit live_studio.new_interactive_course_path
      fill_in :interactive_course_name, with: '一对一互动预览测试'
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

      new_window = window_opened_by { click_on '预览' }
      within_window new_window do
        assert page.has_content? '提示：此页面仅供查看和预览，不能进行操作哦！'
        assert page.has_content? "一对一互动预览测试"
        assert page.has_content? '学习流程'
        assert page.has_content? '购买课程'
        assert page.has_content? '视频直播，白板互动'
      end
      new_window.close
    end

  end
end
