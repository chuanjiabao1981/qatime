require 'test_helper'

module LiveStudio
  # 专属课测试
  class StudentHomeworksTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      @group = live_studio_groups(:published_group1)
      Capybara.current_driver = :selenium_chrome
    end

    def teardown
      new_logout_as(@user) if @user
      Capybara.use_default_driver
    end

    # 老师查看学生提交的作业
    test 'teacher view student homeworks' do
      @group = live_studio_groups(:schedule_published_group1)
      @user = users(:teacher_with_chat_account)
      new_log_in_as(@user)
      visit live_studio.customized_group_path(@group)
      assert page.has_content?("作业 (#{@group.homeworks.count})"), "作业数量显示不正确"
      click_on "作业"
      sleep(1)
      assert page.has_content?("我布置的作业"), "作业tab显示不正确"
      assert page.has_content?("学生提交的作业"), "作业tab显示不正确"
      click_on "学生提交的作业"
      assert page.has_content?("第一个作业"), "作业显示不全"
      assert page.has_content?("student1"), "学生名称显示不正确"
      click_on "第一个作业"
      assert page.has_content?("第1题"), "作业项显示不正确"
    end

    # 学生查看我的作业
    test 'student view student homeworks' do
      @group = live_studio_groups(:schedule_published_group1)
      @user = users(:student_one_with_course)
      new_log_in_as(@user)
      visit live_studio.customized_group_path(@group)
      click_on "作业"
      sleep(1)

      assert page.has_no_content?("我布置的作业"), "学生作业显示不正确"
      assert page.has_content?("第一个作业"), "作业显示不全"
      click_on "第一个作业"
      assert page.has_content?("第1题"), "作业项显示不正确"
    end

    # 学生做作业
    test 'student update self student homeworks' do
      @group = live_studio_groups(:schedule_published_group1)
      @user = users(:student_one_with_course)
      @student_homework = live_studio_tasks(:pending_student_homework)
      new_log_in_as(@user)
      visit live_studio.customized_group_path(@group)
      click_on "作业"
      sleep(1)
      click_on "第2个作业"
      click_on "做作业"
      sleep(1)
      fill_in :student_homework_task_items_attributes_0_body, with: '第1题不会'
      fill_in :student_homework_task_items_attributes_1_body, with: '第2题不会'
      fill_in :student_homework_task_items_attributes_2_body, with: '第3题不会'
      fill_in :student_homework_task_items_attributes_3_body, with: '第4题不会'
      assert_difference "@student_homework.reload.homework.tasks_count", 1, "作业提交数量没有增加" do
        click_on "更新学生作业"
        sleep(1)
      end
      assert @student_homework.submitted?, "作业状态不正确"
      assert page.has_content?("我的答案:"), "作业提交后页面不正确"
      assert page.has_content?("第1题不会"), "作业提交后页面不正确"
    end

    # 老师批改作业
    test 'teacher add correction' do
      @student_homework = live_studio_tasks(:submitted_student_homework)
      @group = live_studio_groups(:schedule_published_group1)
      @user = users(:teacher_with_chat_account)
      new_log_in_as(@user)
      visit live_studio.customized_group_path(@group)
      click_on "作业"
      sleep(1)
      click_on "学生提交的作业"
      click_on "第3个作业"
      click_on "添加批改"
      fill_in :correction_task_items_attributes_0_body, with: '做错了'
      fill_in :correction_task_items_attributes_1_body, with: '做错了'
      fill_in :correction_task_items_attributes_2_body, with: '做错了'
      fill_in :correction_task_items_attributes_3_body, with: '做错了'
      click_on '新增批改'
      sleep(1)
      correction = @student_homework.reload.correction
      assert_not_nil correction, "批改错误"
      assert @student_homework.resolved?, "作业状态不正确"
      click_on '重新批改'
      sleep(1)
      fill_in :correction_task_items_attributes_0_body, with: '做对了'
      fill_in :correction_task_items_attributes_1_body, with: '做对了'
      fill_in :correction_task_items_attributes_2_body, with: '做对了'
      fill_in :correction_task_items_attributes_3_body, with: '做对了'
      assert_no_difference "LiveStudio::Correction.count", "重复批改" do
        click_on '更新批改'
        sleep(1)
      end
      assert_not_includes correction.reload.task_items.map(&:body), "做错了", "重新批改数据错误"
      assert_includes correction.reload.task_items.map(&:body), "做对了", "重新批改数据错误"
    end

    # 未购买学生查看作业
    test 'guest view student homeworks' do
      @user = users(:student1)
      new_log_in_as(@user)
      visit live_studio.customized_group_path(@group)
      click_on "作业"
      sleep(1)
      assert page.has_content?("报名后才能查看"), "未购买作业显示错误"
    end
  end
end
