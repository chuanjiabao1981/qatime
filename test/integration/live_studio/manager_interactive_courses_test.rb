require 'test_helper'

module LiveStudio
  class ManagerInteractiveCoursesTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @manager = users(:manager_zhuji)
      account_result = Typhoeus::Response.new(code: 200, body: { code: 200, info: { accid: 'xxxxx', token: 'thisisatoken' } }.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(account_result)
      log_in_as(@manager)
      visit get_home_url(@manager)
    end

    def teardown
      new_logout_as(@manager)
      Capybara.use_default_driver
    end

    test 'manager interactive_course index' do
      click_on '课程管理'
      click_on '一对一'
      assert page.has_link? '创建新课程'
      assert page.has_content? '测试一对一诸暨'
      assert page.has_link? '预览'
      assert page.has_link? '调课'
      select '高二', from: :q_grade_eq
      select '数学', from: :q_subject_eq
      find(:css, '#show_completed').click
    end

    test 'manager create interactive_course' do
      visit live_studio.new_interactive_course_path
      assert page.has_content? '创建新课程'
      find(:css, '.course-hint').hover
      assert page.has_content? '2.课程总时长共计450分钟，每课45分钟，共10课时（暂不支持修改）；'
      assert page.has_content? '三、其他设置'

      select '高一', from: 'interactive_course_grade'
      select '数学', from: 'interactive_course_subject'
      fill_in :interactive_course_name, with: '一对一互动测试'
      fill_in :interactive_course_objective, with: '课程目标课程目标课程目标课程目标课程目标课程目标课程目'
      fill_in :interactive_course_suit_crowd, with: '课程目标课程目标课程目标课程目标课程目标课程目标课程目标课1'
      find('div[contenteditable]').set('test description')
      fill_in :interactive_course_price, with: '310'
      fill_in :interactive_course_teacher_percentage, with: '90'
      teacher_names = ::Teacher.all.map(&:name)

      click_on '添加新课程'
      sleep(2)
      find('.class_date', match: :first).set((Date.today + 2.days).to_s)
      find('.start_time_hour', match: :first).find(:xpath, 'option[11]').select_option
      find('.start_time_minute', match: :first).find(:xpath, 'option[8]').select_option
      find('.lesson_name', match: :first).set('测试课程名称')
      teacher_html_id = find(:css, '.select2-container').native.attribute('id')
      select2(teacher_names.sample, '#' + teacher_html_id)
      click_on '保存'

      click_on '添加新课程'
      sleep(2)
      find('.class_date', match: :first).set((Date.today + 2.days).to_s)
      find('.start_time_hour', match: :first).find(:xpath, 'option[11]').select_option
      find('.start_time_minute', match: :first).find(:xpath, 'option[8]').select_option
      find('.lesson_name', match: :first).set('测试课程名称2')
      teacher_html_id = find(:css, '.select2-container').native.attribute('id')
      select2(teacher_names.sample, '#' + teacher_html_id)
      click_on '保存'

      assert_difference 'LiveStudio::InteractiveCourse.count', 0, "一对一唯一日期校验失败" do
        assert_difference 'LiveStudio::InteractiveLesson.count', 0, "一对一唯一日期校验失败" do
          click_on '发布招生'
          assert page.has_content? '上课时间不能重复'
        end
      end

      assert_difference 'LiveStudio::InteractiveCourse.count', 1, "一对一创建失败" do
        assert_difference 'LiveStudio::InteractiveLesson.count', 2, "一对一创建失败" do
          click_on '编辑', match: :first
          find('.class_date', match: :first).set((Date.today + 1.days).to_s)
          click_on '保存'
          click_on '发布招生'
        end
      end
      new_interactive_course = LiveStudio::InteractiveCourse.last
      assert new_interactive_course.published?, "新创建今日开课状态不正确 #{new_interactive_course.status}"
    end

    test 'manager interactive_course update_class_date' do
      interactive_course_zhuji = live_studio_interactive_courses(:interactive_course_zhuji)
      visit live_studio.update_class_date_interactive_course_path(interactive_course_zhuji)
      assert page.has_content? interactive_course_zhuji.name
      assert_equal 9, page.all(".adjust-list li").size, "调课只能调unstart的课程"

      lessons = interactive_course_zhuji.interactive_lessons.unstart.order(class_date: :asc)
      lesson1, lesson2 = lessons.first, lessons.second

      # 调重复失败
      find("a[data-target='#adjust_edit_#{lesson1.id}']").click
      sleep(1)
      assert page.has_content? lesson1.teacher.name
      assert page.has_content? lesson1.class_date.to_s
      assert page.has_content? lesson1.start_time
      select2('teacher1', '#s2id_interactive_course_interactive_lessons_attributes_1_teacher_id')
      execute_script("$('#interactive_course_interactive_lessons_attributes_1_class_date').val('#{lesson2.class_date.to_s}')")
      select '09', from: 'interactive_course_interactive_lessons_attributes_1_start_time_hour'
      select '30', from: 'interactive_course_interactive_lessons_attributes_1_start_time_minute'
      click_on '保存'
      assert page.has_content? '修改后> teacher1'
      assert page.has_content? "修改后> #{lesson2.class_date.to_s} 09:30-10:15"
      click_on '保存调课'
      assert page.has_content? '上课时间不能重复'

      find("a[data-target='#adjust_edit_#{lesson1.id}']").click
      sleep(1)
      execute_script("$('#interactive_course_interactive_lessons_attributes_1_class_date').val('#{(lesson1.class_date + 9.days).to_s}')")
      click_on '保存'
      find("a[data-target='#adjust_edit_#{lesson2.id}']").click
      sleep(1)
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

      teacher_names = ::Teacher.all.map(&:name)

      click_on '添加新课程'
      sleep(2)
      find('.class_date', match: :first).set((Date.today + 2.days).to_s)
      find('.start_time_hour', match: :first).find(:xpath, 'option[11]').select_option
      find('.start_time_minute', match: :first).find(:xpath, 'option[8]').select_option
      find('.lesson_name', match: :first).set('测试课程名称')
      teacher_html_id = find(:css, '.select2-container').native.attribute('id')
      select2(teacher_names.sample, '#' + teacher_html_id)
      click_on '保存'

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
