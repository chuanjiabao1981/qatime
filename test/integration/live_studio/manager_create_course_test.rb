require 'test_helper'

module LiveStudio
  class ManagerCreateCourseTest < ActionDispatch::IntegrationTest
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

    test "manager create course" do
      visit live_studio.new_course_path
      assert page.has_content? '创建新直播课'
      assert page.has_content? '2.默认使用系统直播课课程海报'

      fill_in :course_name, with: 'test name'
      select '高一', from: 'course_grade'
      select '数学', from: 'course_subject'
      fill_in :course_objective, with: '课程目标课程目标课程目标课程目标课程目标课程目标课程目标课程目标课程目标课程目标课程目标课程目标课程'
      fill_in :course_suit_crowd, with: '课程目标课程目标课程目标课程目标课程目标课程目标课程目标课1'
      find('div[contenteditable]').set('test description')
      find('#course_tag_list').click
      click_on '小升初考试'
      click_on '周末课'
      click_on '确定'

      click_on '添加新课程'
      find('.class_date', match: :first).set(Time.now.tomorrow.to_s[0,10])
      find('.start_time_hour', match: :first).find(:xpath, 'option[11]').select_option
      find('.start_time_minute', match: :first).find(:xpath, 'option[8]').select_option
      find('select.duration').find(:xpath, 'option[5]').select_option
      find('.lesson_name', match: :first).set('测试课程名称')
      click_on '保存'

      fill_in :course_price, with: '110'
      fill_in :course_teacher_percentage, with: 70
      select2('teacher_one', '#s2id_course_teacher_id')
      count = @manager.live_studio_courses.count
      click_on '发布招生'
      assert_equal @manager.live_studio_courses.last.tag_list, %w(小升初考试 周末课), '标签设置失败'
      assert_equal @manager.live_studio_courses.count, count + 1, '辅导班创建失败'
    end

    test "manager view my_courses" do
      click_on '直播课', match: :first
      click_on '直播课管理'
      assert page.has_link? '创建新课程'
      assert page.has_content? '课程名称'
      assert page.has_content? @manager.live_studio_courses.last.name
    end

    test 'manager course update_class_date' do
      course = live_studio_courses(:course_for_update_class_date)
      visit live_studio.update_class_date_course_path(course)

      assert page.has_content? '调课'
      assert page.has_content? course.name
      assert_equal 3, page.all(".adjust-list li").size, "调课只能调unstart的课程"

      lessons = course.lessons.unstart.order(class_date: :asc)
      lesson1, lesson2 = lessons.first, lessons.second

      find("a[data-target='#adjust_edit_#{lesson1.id}']").click
      assert page.has_content? lesson1.class_date.to_s
      assert page.has_content? lesson1.start_time
      execute_script("$('#course_lessons_attributes_0_class_date').val('#{Date.today.to_s}')")
      select '21', from: 'course_lessons_attributes_0_start_time_hour'
      select '30', from: 'course_lessons_attributes_0_start_time_minute'
      click_on '保存'
      assert page.has_content? "<修改后> #{Date.today.to_s} 21:30-22:00"

      find("a[data-target='#adjust_edit_#{lesson2.id}']").click
      execute_script("$('#course_lessons_attributes_1_class_date').val('#{(lesson2.class_date + 3.days).to_s}')")
      select '21', from: 'course_lessons_attributes_1_start_time_hour'
      select '30', from: 'course_lessons_attributes_1_start_time_minute'
      click_on '保存'
      assert page.has_content? "<修改后> #{(lesson2.class_date + 3.days).to_s} 21:30-22:00"

      click_on '保存调课'
      sleep(3)

      old_class_date2 = lesson2.class_date
      assert_equal lesson1.reload.class_date, Date.today, "调课不成功"
      assert_equal lesson2.reload.class_date, old_class_date2 + 3.days, "调课不成功"
      assert_equal course.reload.status, 'teaching', "调课到今日,课程状态未开课"
    end

  end
end
