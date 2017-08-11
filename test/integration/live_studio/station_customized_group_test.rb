require 'test_helper'

module LiveStudio
  # 工作站专属课测试
  class StationCustomizedGroupTest < ActionDispatch::IntegrationTest
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

    # 专属课创建
    test "manager create customized group" do
      click_on "课程管理"
      click_on "专属课"
      click_on "创建新课程"
      click_on "发布招生"

      assert page.has_content?("请选择年级"), "年级验证不生效"
      assert page.has_content?("请选择科目"), "科目验证不生效"
      assert page.has_content?("请输入课程名称"), "名称验证不生效"
      assert page.has_content?("请输入课程目标"), "课程目标验证不生效"
      assert page.has_content?("请输入适合人群"), "适合人群验证不生效"
      assert page.has_content?("请输入课程介绍"), "课程介绍验证不生效"

      fill_in :customized_group_name, with: '测试专属课'
      select '高一', from: 'customized_group_grade'
      select '数学', from: 'customized_group_subject'
      fill_in :customized_group_objective, with: '课程目标课程目标课程目标课程目标课程目标课程目标课程目标课程目标课程目标课程目标课程目标课程目标课程'
      fill_in :customized_group_suit_crowd, with: '适合人群人群人群人群人群人群人群人群人群'

      # 先上课
      click_on '添加新课程', match: :first
      find('.class_date', match: :first).set(Date.tomorrow.to_s)
      find('.start_at_hour', match: :first).find(:xpath, 'option[11]').select_option
      find('.start_at_min', match: :first).find(:xpath, 'option[8]').select_option
      find('select.duration').find(:xpath, 'option[5]').select_option
      find('.lesson_name', match: :first).set('第一节线上课')
      click_on '保存'

      # 线下课
      find(".offline-live").click_on('添加新课程')

      find('.class_date', match: :first).set(Date.tomorrow.to_s)
      find('.start_at_hour', match: :first).find(:xpath, 'option[11]').select_option
      find('.start_at_min', match: :first).find(:xpath, 'option[8]').select_option
      find('select.duration').find(:xpath, 'option[5]').select_option
      find('.lesson_name', match: :first).set('第一节线下课')
      find('.classaddress', match: :first).set('上课地点')
      click_on '保存'

      find(".offline-live").click_on('添加新课程')

      find('.class_date', match: :first).set(3.days.since.to_date.to_s)
      find('.start_at_hour', match: :first).find(:xpath, 'option[11]').select_option
      find('.start_at_min', match: :first).find(:xpath, 'option[8]').select_option
      find('select.duration').find(:xpath, 'option[5]').select_option
      find('.lesson_name', match: :first).set('第二节线下课')
      find('.classaddress', match: :first).set('上课地点')
      click_on '保存'

      find('div[contenteditable]').set('test description')
      select2('teacher_one', '#s2id_customized_group_teacher_id')
      fill_in :customized_group_price, with: '100'
      fill_in :customized_group_teacher_percentage, with: '60'

      assert_difference "LiveStudio::CustomizedGroup.count", 1, "专属课创建失败" do
        click_on "发布招生"
      end
      course = LiveStudio::CustomizedGroup.last
      assert_equal 3, course.events_count, "课程数量计算不正确"
    end

    test "manager customized group index page" do
      click_on "课程管理"
      click_on "专属课"
      assert page.has_link? '创建新课程'
      assert page.has_content? '专属课调课1'
      assert page.has_link? '预览'
      assert page.has_link? '调课'
      select '高一', from: :q_grade_eq
      select '语文', from: :q_subject_eq
      find(:css, '#show_completed').click
    end

    test "manager update_class_date customized group" do
      customized_group = live_studio_groups(:group_for_update_class_date)
      visit live_studio.update_class_date_station_workstation_customized_group_path(@manager.default_workstation, customized_group)
      assert page.has_content? customized_group.name

      lesson1 = customized_group.scheduled_lessons.first
      lesson2 = customized_group.offline_lessons.first

      find("a[data-target='#adjust_edit_#{lesson1.id}']").click
      assert page.has_content? lesson1.class_date.to_s
      assert page.has_content? lesson1.start_time
      execute_script("$('#customized_group_scheduled_lessons_attributes_0_class_date').val('#{Date.today.to_s}')")
      select '21', from: 'customized_group_scheduled_lessons_attributes_0_start_at_hour'
      select '00', from: 'customized_group_scheduled_lessons_attributes_0_start_at_min'
      click_on '保存'
      assert page.has_content? "修改后> #{Date.today.to_s} 21:00-22:00"

      find("a[data-target='#adjust_edit_#{lesson2.id}']").click
      execute_script("$('#customized_group_offline_lessons_attributes_0_class_date').val('#{(lesson2.class_date + 3.days).to_s}')")
      select '21', from: 'customized_group_offline_lessons_attributes_0_start_at_hour'
      select '00', from: 'customized_group_offline_lessons_attributes_0_start_at_min'
      click_on '保存'
      assert page.has_content? "修改后> #{(lesson2.class_date + 3.days).to_s} 21:00-22:00"

      click_on '保存调课'
      sleep(3)

      old_class_date2 = lesson2.class_date
      assert_equal lesson1.reload.class_date, Date.today, "调课不成功"
      assert_equal lesson2.reload.class_date, old_class_date2 + 3.days, "调课不成功"
      assert_equal customized_group.reload.status, 'teaching', "调课到今日,课程状态未开课"
    end
  end
end
